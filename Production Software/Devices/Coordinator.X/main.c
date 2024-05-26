/* 
 * Coordinator
 * Author:  Michael King
 * 
 * Created on March 18, 2024
 * 
 * This is meant to be a wired network coordinator device, this device is responsible
 * for creating and driving the wired network.
 * this is quite different from the function of other devices on the wired network,
 * so the networking code for this device is unique and separate from all other devices.
 */

#define MAX_MESSAGE_SIZE 200 //maximum message size allowable
#define LIST_LENGTH 255 //max length of device list

#include <stdio.h>
#include <stdlib.h>
#include "USART.h"
#include <avr/io.h>
#include <avr/interrupt.h>
#include "FreeRTOS.h"
#include "task.h"
#include "semphr.h"
#include "event_groups.h"
#include "stream_buffer.h"
#include "message_buffer.h"
#include "ShiftReg.h"

/*
 * Define device specific tasks
 * - Device Specific
 * - Device Specific Initialization
 */

//define device tracking struct
struct DeviceTracker 
{
    uint8_t index;
    uint8_t status;
};

//define priorities

#define mainWIREDINIT_TASK_PRIORITY (tskIDLE_PRIORITY + 4)
#define main485OUT_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define main485IN_TASK_PRIORITY (tskIDLE_PRIORITY + 3)
#define mainROUNDROBIN_TASK_PRIORITY (tskIDLE_PRIORITY + 1)

//helper function prototype
void RS485TR(uint8_t dir);

//Event Groups
EventGroupHandle_t xEventInit;

//task pointers
void prvWiredInitTask( void * parameters );
void prv485OUTTask( void * parameters );
void prv485INTask( void * parameters );
void prvRoundRobinTask( void * parameters );

//stream handles
static StreamBufferHandle_t xRS485_in_Stream = NULL;
static StreamBufferHandle_t xRS485_out_Stream = NULL;
static MessageBufferHandle_t xRS485_out_Buffer = NULL;
static MessageBufferHandle_t xRoundRobin_Buffer = NULL;

//Mutexes
static SemaphoreHandle_t xUSART0_MUTEX = NULL;
static SemaphoreHandle_t xRoundRobin_MUTEX = NULL;

//Semaphores
static SemaphoreHandle_t xRS485TX_SEM = NULL;

//Device Table
static uint8_t GLOBAL_DEVICE_TABLE[LIST_LENGTH];
static uint8_t table_length = 0; //keep track of how many devices initialize

int main(int argc, char** argv) {
    
    //setup tasks
    
    xTaskCreate(prvWiredInitTask, "INIT", 300, NULL, mainWIREDINIT_TASK_PRIORITY, NULL);
    xTaskCreate(prv485OUTTask, "485O", 600, NULL, main485OUT_TASK_PRIORITY, NULL);
    xTaskCreate(prv485INTask, "485I", 600, NULL, main485IN_TASK_PRIORITY, NULL);
    xTaskCreate(prvRoundRobinTask, "RR", 600, NULL, main485IN_TASK_PRIORITY, NULL);
    
    //setup modules (no modules for the coordinator)
    
    //setup event group
    
    xEventInit = xEventGroupCreate();
    
    //setup USART
    
    USART0_init();
    
    //USART 485 control pin
    
    PORTD.DIRSET = PIN7_bm;
    PORTD.OUTCLR = PIN7_bm;
    
    //setup buffers and streams
    
    xRS485_in_Stream = xStreamBufferCreate(20, 1); //size of 20 bytes, 1 byte trigger
    xRS485_out_Stream = xStreamBufferCreate(MAX_MESSAGE_SIZE, 1);
    xRS485_out_Buffer = xMessageBufferCreate(400); //size of 400 bytes
    xRoundRobin_Buffer = xMessageBufferCreate(20); //size of 20 bytes
    
    //setup mutex(es)
    
    xUSART0_MUTEX = xSemaphoreCreateMutex();
    xRoundRobin_MUTEX = xSemaphoreCreateMutex();
    
    //setup semaphore
    
    xRS485TX_SEM = xSemaphoreCreateBinary();
    
    //done with pre-scheduler initialization, start scheduler
    vTaskStartScheduler();
    return (EXIT_SUCCESS);
}

void prvWiredInitTask( void * parameters )
{
    /* Wired Init - Runs Once
     * 1. take USART mutex
     * 2. Generate pings to the entire device list and send them
     * 3. wait up to 2 cycles for a response to start, or else move on to the next device
     * 4. confirm ping response is correct and add device to the list
     * 5. after looping through the entire list, release all other tasks and suspend
     */
    uint8_t Ping[4] = {0x7E, 0x02, 'P', 0};
    uint8_t byte_buffer[1];
    uint8_t length = 0;
    uint8_t buffer[2];
    
    //wait half a second to ensure all wired devices are active
    
    vTaskDelay(500);
    
    //enable transmit complete interrupt
    USART0.CTRLA |= USART_TXCIE_bm;
    
    //take the mutex
    xSemaphoreTake(xUSART0_MUTEX, portMAX_DELAY);
    
    
    //loop and send pings, wait up to 2 cycles for a response, and move to the next one.
    
    for(uint8_t i = 1; i < LIST_LENGTH; i++)
    {
        Ping[3] = i; //configure ping
        xStreamBufferSend(xRS485_out_Stream, Ping, 4, portMAX_DELAY); //load output buffer with ping
        RS485TR('T'); //set transmit mode
        USART0.CTRLA |= USART_DREIE_bm; //start message transmission
        //wait for semaphore
        xSemaphoreTake(xRS485TX_SEM, portMAX_DELAY);
        //transmission is now complete, listen for the response for up to 5 cycles
        xStreamBufferReceive(xRS485_in_Stream, byte_buffer, 1, 5);
        if(byte_buffer[0] == 0x7E)
        {
            uint8_t pos = 0;
            //next byte is length, grab length for message construction loop
            xStreamBufferReceive(xRS485_in_Stream, byte_buffer, 1, portMAX_DELAY);
            length = byte_buffer[0]; // load loop iterator
            //loop and assemble message until length = 0;
            while(length > 0)
            {
                length--;
                xStreamBufferReceive(xRS485_in_Stream, byte_buffer, 1, portMAX_DELAY);
                buffer[pos] = byte_buffer[0];
                pos++;
            }
        }
        //now check ping response for correct number
        if(buffer[0] == 'R')
        {
            if(buffer[1] == i) //if correct response, add to table
            {
                GLOBAL_DEVICE_TABLE[table_length] = i;
                table_length++;
            }
        }
        //otherwise, just ensure that the buffer is cleared and go to next device ID.
        buffer[0] = 0;
    }
    //release the MUTEX
    xSemaphoreGive(xUSART0_MUTEX);
    //The device table and all connected devices should now be initialized.
    //release the init group and suspend the task.
    xEventGroupSetBits(xEventInit, 0x1);
    vTaskSuspend(NULL);
}

void prv485OUTTask( void * parameters )
{
    uint8_t output_buffer[MAX_MESSAGE_SIZE]; //output buffer
    uint8_t wired_leader[3] = {0x7e, 0, 'I'};
    uint8_t length = 0;  //message length
    //this is fairly simple, just output the message buffer when the bus is available.
    //message length should be taken directly from the stream receive.
    //wait for initialization
    xEventGroupWaitBits(xEventInit, 0x1, pdFALSE, pdFALSE, portMAX_DELAY);
    for(;;)
    {
        //wait until a message arrives in the buffer
        length = xMessageBufferReceive(xRS485_out_Buffer, output_buffer, MAX_MESSAGE_SIZE, portMAX_DELAY);
        //acquire MUTEX after pulling message into internal buffer
        xSemaphoreTake(xUSART0_MUTEX, portMAX_DELAY);
        xSemaphoreTake(xRoundRobin_MUTEX, portMAX_DELAY);
        //load the length of the message into the wired leader
        wired_leader[1] = length + 1; //including direction byte
        //add the message leader into the output buffer
        xStreamBufferSend(xRS485_out_Stream, wired_leader, 3, portMAX_DELAY);
        //pass message to the output buffer
        xStreamBufferSend(xRS485_out_Stream, output_buffer, length, portMAX_DELAY);
        //set transmit mode
        RS485TR('T');
        //enable DRE interrupt to start transmission
        USART0.CTRLA |= USART_DREIE_bm;
        //wait for TXcomplete semaphore
        xSemaphoreTake(xRS485TX_SEM, portMAX_DELAY);
        //release MUTEXes
        xSemaphoreGive(xRoundRobin_MUTEX);
        xSemaphoreGive(xUSART0_MUTEX);
        //end of loop, start over by waiting for a new message in the buffer
    }
}

void prv485INTask( void * parameters )
{
    /* listen for messages on bus
     * - Grab the mutex when a message comes in on the bus
     * - there may be multiple messages in a stream, process them appropriately based on destination
     * = for messages with a wireless address, send them to the wireless task
     * = for messages addressed to channel 0, send them to the menu task
     * = for messages intended only for devices on the wired bus, no further action is needed
     * = ping response should be passed to the round robin task, this also marks the end of a message stream
     * 
     * 1. wait until message start is received, start collecting and building messages
     * 2. route messages to appropriate destination task
     * 3. ping response marks the end of a stream
     */
    uint8_t message_buffer[MAX_MESSAGE_SIZE];
    uint8_t byte_buffer[1];
    uint8_t length = 0; //message length from header
    //wait for initialization
    xEventGroupWaitBits(xEventInit, 0x1, pdFALSE, pdFALSE, portMAX_DELAY);
    for(;;)
    {
        //wait for something to appear on the bus
        xStreamBufferReceive(xRS485_in_Stream, byte_buffer, 1, portMAX_DELAY);
        //check for start delimiter
        if(byte_buffer[0] == 0x7e)
        {
            //take mutex
            xSemaphoreTake(xUSART0_MUTEX, portMAX_DELAY);
            //next byte should be length
            xStreamBufferReceive(xRS485_in_Stream, byte_buffer, 1, portMAX_DELAY);
            length = byte_buffer[0];
        }
        else
            length = 0; //just ignore this message, something went wrong
        
        //now we hold the MUTEX and know the message length(if there is a message)
        for(uint8_t i = 0; i < length; i++)
        {
            //assemble the message byte by byte until the length is reached
            if(xStreamBufferReceive(xRS485_in_Stream, byte_buffer, 1, 5) != 0)
                message_buffer[i] = byte_buffer[0];
            //if nothing is received, cancel message receipt. Something went wrong
            else
                i = length;
            //this if/else statement constitutes collision recovery code.
            //if a collision occurs and breaks the loop, the timeout will save us from getting trapped here.
        }
        //now the full message should be within the message buffer, perform routing
        if(length != 0)
        {
            uint8_t wirelesscheck = 0;
            switch(message_buffer[0])
            {
                case 'R': //ping response
                    //pass the target ID on to the round robin buffer
                    byte_buffer[0] = message_buffer[1];
                    xMessageBufferSend(xRoundRobin_Buffer, byte_buffer, 1, portMAX_DELAY);
                    //release the mutex, this is the end of the message
                    xSemaphoreGive(xUSART0_MUTEX);
                    break;
                case 'O': //outbound message, check for wireless address or channel 0
                    //check for wireless address first, as there may be multiple menu controllers and we don't want to send it duplicate messages
                    wirelesscheck = 0;
                    for(uint8_t i = 11; i >= 4; i--) //byte 4 to 11 are for xBee address, if there is anything in here then send it to the wireless task
                    {   //reverse check should be faster than forwards in most cases
                        if(message_buffer[i] != 0)
                        {
                            wirelesscheck = 1;
                            i = 12;
                        }
                    }
                    
                    if(wirelesscheck != 0) //if there is a wireless address, route to the wireless task
                    {
                        //not yet set up, just ignore for now
                    }
                    else if(message_buffer[2] == 0) //send to menu controller (if attached)
                    {
                        //not yet set up, just ignore for now
                    }
                    break;
            }
        }
        
    }
}

void prvRoundRobinTask( void * parameters )
{
    uint8_t Ping[4] = {0x7e, 0x02, 'P', 0};
    uint8_t acknowledge[1];
    //wait for initialization
    xEventGroupWaitBits(xEventInit, 0x1, pdFALSE, pdFALSE, portMAX_DELAY);
    //enter main task loop
    for(;;)
    {
        for(uint8_t count = 0; count < table_length; count++)
        {
            //first, try to secure the RS485 line
            xSemaphoreTake(xUSART0_MUTEX, portMAX_DELAY);
            //then, secure the output
            xSemaphoreTake(xRoundRobin_MUTEX, portMAX_DELAY);
            //set target to the current address pointed to by count
            Ping[3] = GLOBAL_DEVICE_TABLE[count];
            //pass message into the output buffer
            xStreamBufferSend(xRS485_out_Stream, Ping, 4, portMAX_DELAY);
            //set to output mode
            RS485TR('T');
            //start transmission by enabling the DRE interrupt
            USART0.CTRLA |= USART_DREIE_bm;
            //wait for TXcomplete semaphore
            xSemaphoreTake(xRS485TX_SEM, portMAX_DELAY);
            //release USART MUTEX
            xSemaphoreGive(xUSART0_MUTEX);
            //wait for a response from the message stream
            //receives from round robin buffer, puts into acknowledge array, max length 1, waits max 250 cycles
            xMessageBufferReceive(xRoundRobin_Buffer, acknowledge, 1, 250);
            //check response
            if(GLOBAL_DEVICE_TABLE[count] != acknowledge[0])
            {
                vTaskDelay(50);
                xSemaphoreGive(xRoundRobin_MUTEX);
            } //break here for debug purposes
            else
            xSemaphoreGive(xRoundRobin_MUTEX); //release round robin
            //end of loop, start again after incrementing
        }
    }
}

//helper functions:

//RS485 in/out
void RS485TR(uint8_t dir)
{
    //set transceiver direction
    switch(dir)
    {
        case 'T': //transmit
            PORTD.OUTSET = PIN7_bm;
            break;
        case 'R': //receive
            PORTD.OUTCLR = PIN7_bm;
            break;
        default: //incorrect command
            break;
    }
}

ISR(USART0_RXC_vect)
{
    //move the data receive register into the stream for the input task, this clears the interrupt automatically
    uint8_t buf[1];
    buf[0] = USART0.RXDATAL;
    xMessageBufferSendFromISR(xRS485_in_Stream, buf, 1, NULL);
}
ISR(USART0_DRE_vect)
{
    /* Data Register empty Interrupt
     * 1. pull from output stream buffer and put in TX register until clear
     * 2. disable interrupt after end of message
     */
    uint8_t buf[1];
    if(xStreamBufferReceiveFromISR(xRS485_out_Stream, buf, 1, NULL) == 0) //if end of message
    {
        USART0.CTRLA &= ~USART_DREIE_bm; //disable interrupt
    }
    else
        USART0.TXDATAL = buf[0];
}
ISR(USART0_TXC_vect)
{
    /* Transmission complete interrupts
     * 1. set semaphore
     * 2. clear interrupt flag
     * 3. return transceiver to receive mode
     */
    //return transceiver to receive mode
    RS485TR('R');
    USART0.STATUS |= USART_TXCIF_bm; //clear flag by writing a 1 to it
    xSemaphoreGiveFromISR(xRS485TX_SEM, NULL);
}