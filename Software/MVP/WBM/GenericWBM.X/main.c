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

static struct Device GLOBAL_DEVICE_TABLE[250]; //create device table

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
    xTaskCreate(prvRS485OutTask, "RSOUT", 400, NULL, mainRS485OUT_TASK_PRIORITY, NULL);
    xTaskCreate(prvRS485InTask, "RSIN", 400, NULL, mainRS485IN_TASK_PRIORITY, NULL);
    xTaskCreate(prvTableWriteTask, "TABLE", 300, NULL, mainTABLEWRITE_TASK_PRIORITY, NULL);
    xTaskCreate(prvPbInTask, "PBIN", 250, NULL, mainPBIN_TASK_PRIORITY, NULL);
    xTaskCreate(prvIndOutTask, "INDOUT", 250, NULL, mainINDOUT_TASK_PRIORITY, NULL);
    xTaskCreate(prvWBMTask, "WBM", 600, NULL, mainWBM_TASK_PRIORITY, NULL);
    
    //setup device ID and channel here
    
    //initialize device table to all 0s?
    
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


ISR(USART0_RXC_vect)
{
    
}
ISR(USART0_DRE_vect)
{
    
}
ISR(USART0_TXC_vect)
{
    
}