/* 
 * File:   main.c - Coordinator
 * Author: Michael King
 * MVP version
 *
 * The purpose of this is to create a minimum viable coordinator running code, 
 * to start, this needs at least the RS485 read and write tasks, as well as the
 * round robin task to drive the wired network. Then we can begin testing other
 * wired modules as well.
 * Created on March 15, 2024, 8:49 AM
 */
/* Version one: RS485 only
 * The purpose of this is to provide a testbed for the RS485 network,
 * it uses just the round robin to drive the wired network, no other tasks are
 * implemented.
 */
#include <stdio.h>
#include <stdlib.h>
#include "USART.h"
#include <avr/io.h>
#include <avr/interrupt.h>
#include "FreeRTOS.h"
#include "task.h"
#include "semphr.h"
#include "stream_buffer.h"
#include "message_buffer.h"


#define MAX_MESSAGE_SIZE 200 //maximum message size allowable

// Priority Definitions:

#define mainROUNDROBIN_TASK_PRIORITY (tskIDLE_PRIORITY + 1)
#define mainRS485OUT_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainRS485IN_TASK_PRIORITY (tskIDLE_PRIORITY + 3)

// Task pointers

static void prvRoundRobinTask( void *parameters );
static void prvRS485OutTask( void *parameters );
static void prvRS485InTask( void *parameters );

//Mutexes
static SemaphoreHandle_t xUSART0_MUTEX = NULL;
static SemaphoreHandle_t xRoundRobin_MUTEX = NULL;

//Semaphores


static SemaphoreHandle_t xRS485TX_SEM = NULL;

//stream handles
static StreamBufferHandle_t xRS485_in_Stream = NULL;
static MessageBufferHandle_t xRS485_out_Buffer = NULL;
static MessageBufferHandle_t xRoundRobin_Buffer = NULL;


int main(int argc, char** argv) {
    //clock is set by FreeRTOS
    //enable USART0 (RS485 USART)
    USART0_init();
    //set output mode for PD7 (485W) and ensure it is clear
    PORTD.DIRSET = PIN7_bm;
    PORTD.OUTCLR = PIN7_bm;
    //setup buffers and streams
    
    xRS485_in_Stream = xStreamBufferCreate(20, 1); //size of 10 bytes, 1 byte trigger
    xRS485_out_Buffer = xMessageBufferCreate(400); //size of 400 bytes
    xRoundRobin_Buffer = xMessageBufferCreate(20); //size of 20 bytes
    
    //setup mutex(es)
    
    xUSART0_MUTEX = xSemaphoreCreateMutex();
    xRoundRobin_MUTEX = xSemaphoreCreateMutex();
    
    //setup semaphore
    
    xRS485TX_SEM = xSemaphoreCreateBinary();
    
    //setup tasks
    
    //round robin is setup with 500bytes of allocated stack, name of ROBIN
    //500 bytes because it needs to hold an array of active devices (eventually)
    xTaskCreate(prvRoundRobinTask, "ROBIN", 500, NULL, mainROUNDROBIN_TASK_PRIORITY, NULL);
    //200 bytes of allocated stack for RS485OUT (needs to hold a full message)
    xTaskCreate(prvRS485OutTask, "RSOUT", 400, NULL, mainRS485OUT_TASK_PRIORITY, NULL);
    //400 bytes of allocated stack for RS485in (needs to hold a full message)
    xTaskCreate(prvRS485InTask, "RSIN", 400, NULL, mainRS485IN_TASK_PRIORITY, NULL);
    return (EXIT_SUCCESS);
}

static void prvRoundRobinTask(void * parameters)
{
    //send a ping to each channel on the bus sequentially
    //message length as short as possible 
    uint8_t message[13];
    uint8_t acknowledge[1];
    for(uint8_t i = 0; i < 13; i++)
        message[i] = 0;
    message[0] = 0xAA; //wired preamble
    message[10] = 0xFF; //broadcast channel
    message[11] = 0x05; //enquire
    message[12] = 0x03; //end of message
    //initialization complete, begin looping code
    for(;;)
    {
        for(uint8_t count = 1; count < 3; count++) //count is only 3 for testing
        {
            /* process:
             * secure both MUTEXes
             * set RS485 transceiver to transmit mode
             * ping the device by looping through the message byte by byte until complete
             * return the transceiver to receive mode
             * release the USART MUTEX
             * wait for response
             * check response, release robin MUTEX
             * go to next number when available again
             */
            //first, try to secure the RS485 line
            xSemaphoreTake(xUSART0_MUTEX, portMAX_DELAY);
            //then, secure output
            xSemaphoreTake(xRoundRobin_MUTEX, portMAX_DELAY);
            //set message to the current counter address
            message[9] = count;
            //set RS485 transceiver to transmit mode
            PORTD.OUTSET = PIN7_bm;
            //loop through message (block and wait for semaphore)
            for(uint8_t i = 0; i < 13; i++)
            {
                USART0.TXDATAL = message[i]; //begin transmission
                xSemaphoreTake(xRS485TX_SEM, portMAX_DELAY); //wait until TX complete
            }
            //return transceiver to receive mode
            PORTD.OUTCLR = PIN7_bm;
            //release USART MUTEX
            xSemaphoreGive(xUSART0_MUTEX);
            //wait for a response in the message queue
            //receives from round robin buffer, puts into acknowledge array, max length 1, waits forever
            xMessageBufferReceive(xRoundRobin_Buffer, acknowledge, 1, portMAX_DELAY);
            //check response
            if(count != acknowledge[0])
            {} //do nothing yet
            else
                xSemaphoreGive(xRoundRobin_MUTEX); //release round robin
            //end of loop, start again after incrementing
        }
        //start loop again
    }
}
static void prvRS485OutTask(void * parameters)
{
    /*send procedure:
     * 1. wait until a message arrives in the buffer
     * 2. acquire USART MUTEX and round robin MUTEX
     * 3. transceiver to send mode
     * 4. send message by looping through byte by byte
     * 5. transceiver to receive mode
     * 6. release USART MUTEX and round robin MUTEX
     */
    uint8_t output_buffer[MAX_MESSAGE_SIZE]; //output buffer
    uint8_t length = 0; //message length
    //initialization complete, begin looping portion
    for(;;)
    {
        //wait until a message arrives in the buffer
        length = xMessageBufferReceive(xRS485_out_Buffer, output_buffer, MAX_MESSAGE_SIZE, portMAX_DELAY);
        //acquire MUTEX after pulling message into internal buffer
        xSemaphoreTake(xUSART0_MUTEX, portMAX_DELAY);
        xSemaphoreTake(xRoundRobin_MUTEX, portMAX_DELAY);
        //transceiver to send mode
        PORTD.OUTSET = PIN7_bm;
        //send message by looping
        for(int i = 0; i < length; i++)
        {
            USART0.TXDATAL = output_buffer[i]; //begin transmission
            USART0.CTRLA |= USART_DREIE_bm; //enable interrupt
            xSemaphoreTake(xRS485TX_SEM, portMAX_DELAY); //wait until TX complete
        }
        //return to receive mode
        PORTD.OUTCLR = PIN7_bm;
        //release MUTEXes
        xSemaphoreGive(xRoundRobin_MUTEX);
        xSemaphoreGive(xUSART0_MUTEX);
        //end of loop, start over by waiting for a new message in the buffer
    }
}
static void prvRS485InTask(void * parameters)
{
    /* receive procedure:
     * 1. wait for something to appear on the input stream buffer (start delimiter 0xAA)
     * 2. take the USART MUTEX
     * 3. add the message to an input buffer sequentially
     * 4. wait between bytes
     * 5. stop looping when end delimiter received
     * 6. release MUTEX
     * 7. decide where to route message based on context
     */
    uint8_t message_buffer[MAX_MESSAGE_SIZE];
    uint8_t byte_buffer[1];
    uint8_t length = 0; //message length increments with each bit
    //initialization complete
    for(;;)
    {
        length = 0;
        //wait for something to come in
        xStreamBufferReceive(xRS485_in_Stream, byte_buffer, 1, portMAX_DELAY);
        if(byte_buffer != 0xAA) //if not start delimiter, break somehow
        {} // just discard it
        else
        {
            //take MUTEX
            xSemaphoreTake(xUSART0_MUTEX, portMAX_DELAY);
            //loop and assemble message until end delimiter received
            for(int i = 0; i < MAX_MESSAGE_SIZE; i++)
            {
                xStreamBufferReceive(xRS485_in_Stream, byte_buffer, 1, portMAX_DELAY);
                //check if delimiter
                if(byte_buffer[0] == 0x03)
                {
                    //don't increment length, end loop
                    i = MAX_MESSAGE_SIZE;
                }
                else
                {
                    message_buffer[i] = byte_buffer[0]; // add to message buffer
                    length++; //increment length
                }
            }
            //assembled message is within the buffer, end delimiter received
            //release MUTEX and perform routing
            xSemaphoreGive(xUSART0_MUTEX);
            /* routing options:
             * always send device ID to round robin task
             * menu - if channel is 0
             * wireless - if wireless address is populated
             * discard if the above two conditions are not true
             */
            //device ID should always be byte 8 (counting from 0)
            byte_buffer[0] = message_buffer[8];
            //send ID to round robin task
            xMessageBufferSend(xRoundRobin_Buffer, byte_buffer, 1, portMAX_DELAY);
            //check channel, should always be byte 9 (counting from 0)
            if(message_buffer[9] == 0) //if channel 0
            {
                //send to menu
                //NOT YET IMPLEMENTED
            }
            //check if there is anything in the wireless address section
            for(int i = 0; i < 8; i++)
            {
                if(message_buffer[i] != 0) //if a byte does not = 0
                {
                    //stop looping check, send message to wireless section
                    i = 8; //stop loop
                    //NOT YET IMPLEMENTED
                }
            }
            //if buffer needs to be cleared out, do it here
        }
            
    }
}

//now setup interrupts for the RS485 section

ISR(USART0_RXC_vect)
{
    //move the data receive register into the stream for the input task, this clears the interrupt automatically
    xMessageBufferSendFromISR(xRS485_in_Stream, USART0.RXDATAL, 1, NULL);
}

ISR(USART0_DRE_vect)
{
    /* Data Register empty Interrupt
     * 1. set the semaphore
     * 2. disable interrupt
     */
    xSemaphoreGiveFromISR(xRS485TX_SEM, NULL);
    USART0.CTRLA &= ~USART_DREIE_bm; //disable interrupt, may be a better way to accomplish this?
}