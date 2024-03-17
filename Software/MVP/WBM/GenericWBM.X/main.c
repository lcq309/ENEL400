/* 
 * File:   main.c - WBM Generic
 * Author: Michael King
 * MVP version
 *
 * The purpose of this is to create a minimum viable running code for the Wired 
 * Button Modules, this code is for the general case.
 * Created on March 17, 2024
 */
/* Version one: Basics only
 * The purpose of this is to provide a testbed for the RS485 network, and networking
 * in general. No optional features are included
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

#define MAX_MESSAGE_SIZE 200 //maximum message size allowable, includes formatting
#define DEVICE_TABLE_SIZE 250

static uint8_t GLOBAL_DeviceID = 0; //device ID is set during initial startup
static uint8_t GLOBAL_Channel = 0; //channel number is set during initial startup
static uint8_t GLOBAL_DeviceType = 1; //this will be device type 1, generic controller

struct Device { //defined in the Device Table Concepts.txt file
    uint8_t XBeeADD[8];
    uint8_t WiredADD;
    uint8_t Channel;
    uint8_t Type;
    uint8_t Flags;
};

static struct Device GLOBAL_DEVICE_TABLE[DEVICE_TABLE_SIZE]; //create device table

// Priority Definitions:

#define mainWIREDINIT_TASK_PRIORITY (tskIDLE_PRIORITY + 4)
#define mainRS485OUT_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainRS485IN_TASK_PRIORITY (tskIDLE_PRIORITY + 3)
#define mainTABLEWRITE_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainPBIN_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainINDOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainWBM_TASK_PRIORITY (tskIDLE_PRIORITY + 1)

// Task pointers

static void prvWiredInitTask ( void *parameters );
static void prvRS485OutTask ( void *parameters );
static void prvRS485InTask ( void *parameters );
static void prvTableWriteTask ( void *parameters );
static void prvPbInTask ( void *parameters );
static void prvIndOutTask ( void *parameters );
static void prvWBMTask ( void *parameters );

//Mutexes

static SemaphoreHandle_t xUSART0_MUTEX = NULL;
static SemaphoreHandle_t xTABLE_MUTEX = NULL;
static SemaphoreHandle_t xDeviceBuffer_MUTEX = NULL;

//Semaphores

//no semaphores for this device, uses only direct notification

//stream handles

static StreamBufferHandle_t xRS485_in_Stream = NULL;
static StreamBufferHandle_t xRS485_out_Stream = NULL;
static MessageBufferHandle_t xRS485_out_Buffer = NULL;
static MessageBufferHandle_t xTableWrite_Buffer = NULL;
static MessageBufferHandle_t xDevice_Buffer = NULL;

//queue handles

static QueueHandle_t xPB_Queue = NULL;
static QueueHandle_t xIND_Queue = NULL;

//device table


int main(int argc, char** argv) {
    //clock is set by FreeRTOS
    //enable USART0 (RS485 USART)
    USART0_init();
    //set output mode for PD7 (485W) and ensure it is clear
    PORTD.DIRSET = PIN7_bm;
    PORTD.OUTCLR = PIN7_bm;
    //setup buffers and streams
    
    xRS485_in_Stream = xStreamBufferCreate(20,1); //20 bytes, triggers when a byte is added
    xRS485_out_Stream = xStreamBufferCreate(MAX_MESSAGE_SIZE, 1); //output buffer
    xRS485_out_Buffer = xMessageBufferCreate(400);
    xTableWrite_Buffer = xMessageBufferCreate(50);
    xDevice_Buffer = xMessageBufferCreate(200);
    
    //setup Queues
    
    xPB_Queue = xQueueCreate(3, sizeof(uint8_t)); //up to 3 button presses held
    xIND_Queue = xQueueCreate(3, 2 * sizeof(uint8_t)); // up to 3 Indicator Commands held
    
    //setup mutex(es)
    
    xUSART0_MUTEX = xSemaphoreCreateMutex();
    xTABLE_MUTEX = xSemaphoreCreateMutex();
    xDeviceBuffer_MUTEX = xSemaphoreCreateMutex();
    
    //setup semaphore
    //no semaphore for this one
    
    //setup tasks
    
    xTaskCreate(prvWiredInitTask, "INIT", 300, NULL, mainWIREDINIT_TASK_PRIORITY, NULL);
    xTaskCreate(prvRS485OutTask, "RSOUT", 500, NULL, mainRS485OUT_TASK_PRIORITY, NULL);
    xTaskCreate(prvRS485InTask, "RSIN", 400, NULL, mainRS485IN_TASK_PRIORITY, NULL);
    xTaskCreate(prvTableWriteTask, "TABLE", 300, NULL, mainTABLEWRITE_TASK_PRIORITY, NULL);
    xTaskCreate(prvPbInTask, "PBIN", 250, NULL, mainPBIN_TASK_PRIORITY, NULL);
    xTaskCreate(prvIndOutTask, "INDOUT", 250, NULL, mainINDOUT_TASK_PRIORITY, NULL);
    xTaskCreate(prvWBMTask, "WBM", 600, NULL, mainWBM_TASK_PRIORITY, NULL);
    
    //setup device ID and channel here
    !!
    //initialize device table to all 0s?
    !!
    vTaskStartScheduler(); //start scheduler
    return (EXIT_SUCCESS);
}

//now setup interrupts for the RS485 section

static void prvWiredInitTask(void * parameters)
{
    /* Wired Init Task
     * 1. take RS485 MUTEX
     * 2. start flashing indicators
     * 3. listen and wait for correct init message (collect device number before starting scheduler)
     * 4. Set Transmit mode
     * 5. reply to init message with device ID number (DREIE as well)
     * 6. Set Receive mode after TXCIF
     * 7. stop flashing lights
     * 8. send network join message to the RS485 output buffer
     * 9. enable TXCIE
     * 10. release RS485 MUTEX
     * 11. sleep until reset
     */
    for(;;){
    //1. Take RS485 MUTEX
    xSemaphoreTake(xUSART0_MUTEX, portMAX_DELAY);
    //2. Start Flashing Indicators
    uint8_t lightsFlash[2] = {0x255, 0x2};
    xQueueSendToFront(xPB_Queue ,$lightsFlash, portMAX_DELAY);
    //3. Listen for correct init message
    uint8_t ByteBuffer[1];
    /*
     * process the 3 byte message that comes in over the bus, when number
     * matches our number, prepare to send a reply
     */
    uint8_t received = 0;
    while(received != 1)
    {
        //wait for buffer
        xStreamBufferReceive(xRS485_in_Stream, ByteBuffer, 1, portMAX_DELAY);
        if(ByteBuffer[0] != 0xAA) //start delimiter, next byte should be device ID during init
        {
            xStreamBufferReceive(xRS485_in_Stream, ByteBuffer, 1, portMAX_DELAY);
            if(ByteBuffer[0] == GLOBAL_DeviceID)// if this is the right device
            {
                received = 1;
            }
        }
        // just loop and discard anything else
    }
    //now we have been contacted by the master controller, we must reply
    ByteBuffer[0] = GLOBAL_DeviceID; //message prepared
    //load device ID into output buffer
    xStreamBufferSend(xRS485_out_Stream, ByteBuffer, 1, portMAX_DELAY);
    //start transmit mode
    PORTD.OUTSET = PIN7_bm;
    //send preamble to output buffer
    USART0.TXDATAL = 0xAA;
    //enable DRE interrupt
    USART0.CTRLA |= USART_DREIE_bm;
    //after it returns from the interrupt, wait for transmission to complete
    while(!USART0.STATUS & USART_TXCIF_bm); //just busy wait until done
    //now that transmission has finished, clear flag and set to receive mode
    USART0.STATUS |= USART_TXCIF_bm;
    PORTD.OUTCLR = PIN7_bm;
    //stop flashing lights
    lightsFlash[1] = 0; //command 0, off
    xQueueSendToFront(xPB_Queue ,$lightsFlash, portMAX_DELAY);
    //send network join message to RS485 output buffer
    uint8_t StartMessage[11] = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xFF, 0xFF, GLOBAL_DeviceID, GLOBAL_Channel, GLOBAL_DeviceType};
    xMessageBufferSend(xRS485_out_Buffer, StartMessage, 11, portMAX_DELAY);
    //enable TXCIE
    USART0.CTRLA |= USART_TXCIE_bm;
    //release MUTEX
    xSemaphoreGive(xUSART0_MUTEX);
    //go to sleep until restart
    vTaskSuspend(NULL);
    }
}   

static void prvRS485OutTask(void * parameters)
{
    /* RS485 Out Handler
     * 1. wait on notification[1] from in task
     * 2. acquire MUTEX
     * 3. check if there is something waiting to send
     * 4. send either message, or ping response to output buffer 
     * 5. set transmit mode
     * 6. send preamble to the usart tx register
     * 7. enable DREIE
     * 8. wait for notification[1] from TXCISR
     * 9. set to receive mode
     * 10. release MUTEX
     */
    for(;;){
    uint8_t buffer[MAX_MESSAGE_SIZE];
    // wait for notification
    xTaskNotifyWaitIndexed(1, NULL, NULL, NULL, portMAX_DELAY);
    //acquire mutex
    xSemaphoreTake(xUSART0_MUTEX, portMAX_DELAY);
    //check for waiting output message
    uint8_t size = xMessageBufferReceive(xRS485_out_Buffer, buffer, MAX_MESSAGE_SIZE, NULL);
    if(size != 0) // if there is a message
    {
     /* send a message
      * 1. check instruction from device specific
      * 2. enter message loop
      * 3. grab MUTEX for table
      * 4. find next entry in table
      * 5. send to entry
      * 6. release MUTEX for table
      * 7. start transmission
      * 8. set receive mode after TXCISR notification
      * 9. release MUTEX for RS485
      * 10. wait for next send window
      */
        //check instruction
        if(buffer[size - 2] == 0) //index entry
        {
            //take table MUTEX
            xSemaphoreTake(xTABLE_MUTEX, portMAX_DELAY);
            //pull information from table, load the output buffer with 8 byte address
            xStreamBufferSend(xRS485_out_Stream, GLOBAL_DEVICE_TABLE[buffer[size - 1]].XBeeADD, 8, portMAX_DELAY);
            //next load the 1 byte wired address
            xStreamBufferSend(xRS485_out_Stream, GLOBAL_DEVICE_TABLE[buffer[size - 1]].WiredADD, 1, portMAX_DELAY);
            //next load the channel
            xStreamBufferSend(xRS485_out_Stream, GLOBAL_DEVICE_TABLE[buffer[size - 1]].Channel, 1, portMAX_DELAY);
            //next load the device type
            xStreamBufferSend(xRS485_out_Stream, GLOBAL_DEVICE_TABLE[buffer[size - 1]].Type, 1, portMAX_DELAY);
            //don't need the table anymore, drop the MUTEX
            xSemaphoreGive(xTABLE_MUTEX);
            //next load the message (subtract last 2 bytes for commands)
            xStreamBufferSend(xRS485_out_Stream, buffer, size - 2, portMAX_DELAY);
            //full message should be loaded into the output buffer now, prepare to start sending
            PORTD.OUTSET = PIN7_bm; //set transmit mode
            //send preamble to start transmisson
            USART0.TXDATAL = 0xAA;
            //enable DRE interrupt
            USART0.CTRLA |= USART_DREIE_bm;
            //wait for TXcomplete notification
            xTaskNotifyWaitIndexed(1, NULL, NULL, NULL, portMAX_DELAY);
            //return to receive mode
            PORTD.OUTCLR = PIN7_bm;
            //release USART MUTEX
            xSemaphoreGive(xUSART0_MUTEX);
            //now complete message sending process, return to start of loop
        }
        else if(buffer[size - 2] == 0x05) //relevant devices
        {
            /* relevant devices
             * 1. grab table MUTEX
             * 2. loop through table until first relevant device found, keep track of index position
             * 3. load into message output (same as above)
             * 4. release table MUTEX
             * 5. load message into message output from buffer
             * 6. perform transmission process
             * 7. release RS485 MUTEX
             * 8. wait until next notification
             * 9. loop until entire table is cleared
             */
            //grab table mutex
            xSemaphoreTake(xTABLE_MUTEX, portMAX_DELAY);
            //search table for devices marked relevant
            for(uint8_t count = 0; count < DEVICE_TABLE_SIZE; count++)
            {
                if(GLOBAL_DEVICE_TABLE[count].Flags & 0x01 == 1) //relevant device
                {
                    //pull information from table, load the output buffer with 8 byte address
                    xStreamBufferSend(xRS485_out_Stream, GLOBAL_DEVICE_TABLE[count].XBeeADD, 8, portMAX_DELAY);
                    //next load the 1 byte wired address
                    xStreamBufferSend(xRS485_out_Stream, GLOBAL_DEVICE_TABLE[count].WiredADD, 1, portMAX_DELAY);
                    //next load the channel
                    xStreamBufferSend(xRS485_out_Stream, GLOBAL_DEVICE_TABLE[count].Channel, 1, portMAX_DELAY);
                    //next load the device type
                    xStreamBufferSend(xRS485_out_Stream, GLOBAL_DEVICE_TABLE[count].Type, 1, portMAX_DELAY);
                    //don't need the table anymore, drop the MUTEX
                    xSemaphoreGive(xTABLE_MUTEX);
                    //next load the message (subtract last 2 bytes for commands)
                    xStreamBufferSend(xRS485_out_Stream, buffer, size - 2, portMAX_DELAY);
                    //full message should be loaded into the output buffer now, prepare to start sending
                    PORTD.OUTSET = PIN7_bm; //set transmit mode
                    //send preamble to start transmission
                    USART0.TXDATAL = 0xAA;
                    //enable DRE interrupt
                    USART0.CTRLA |= USART_DREIE_bm;
                    //wait for TXcomplete notification
                    xTaskNotifyWaitIndexed(1, NULL, NULL, NULL, portMAX_DELAY);
                    //return to receive mode
                    PORTD.OUTCLR = PIN7_bm;
                    //release USART MUTEX
                    xSemaphoreGive(xUSART0_MUTEX);
                    //now complete message sending process, wait for the next opportunity
                    xTaskNotifyWaitIndexed(1, NULL, NULL, NULL, portMAX_DELAY);
                    //grab USART MUTEX
                    xSemaphoreTake(xUSART0_MUTEX, portMAX_DELAY);
                }
            }
        }
        else // ping response, generic response is anything (or nothing in this case)
        {
            /* 1. assemble message in buffer as above
             * 2. perform sending process as above
             * 3. go back to start of task loop
             */
            //load the output buffer with 8 byte address (all 0's)
            xStreamBufferSend(xRS485_out_Stream, 0x00000000, 8, portMAX_DELAY);
            //next load the 1 byte wired address
            xStreamBufferSend(xRS485_out_Stream, GLOBAL_DeviceID, 1, portMAX_DELAY);
            //next load the channel
            xStreamBufferSend(xRS485_out_Stream, GLOBAL_Channel, 1, portMAX_DELAY);
            //next load the device type
            xStreamBufferSend(xRS485_out_Stream, GLOBAL_DeviceType, 1, portMAX_DELAY);
            //full message should be loaded into the output buffer now, prepare to start sending
            PORTD.OUTSET = PIN7_bm; //set transmit mode
            //send preamble to start transmission
            USART0.TXDATAL = 0xAA;
            //enable DRE interrupt
            USART0.CTRLA |= USART_DREIE_bm;
            //wait for TXcomplete notification
            xTaskNotifyWaitIndexed(1, NULL, NULL, NULL, portMAX_DELAY);
            //return to receive mode
            PORTD.OUTCLR = PIN7_bm;
            //release USART MUTEX
            xSemaphoreGive(xUSART0_MUTEX);
        }
    }
    }
}

ISR(USART0_RXC_vect)
{
    
}
ISR(USART0_DRE_vect)
{
    
}
ISR(USART0_TXC_vect)
{
    
}