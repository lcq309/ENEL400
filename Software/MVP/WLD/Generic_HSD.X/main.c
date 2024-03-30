/* 
 * File:   main.c - WLD Generic
 * Author: Michael King
 * MVP version
 *
 * The purpose of this is to create a minimum viable running code for the Wired 
 * Light Modules, this code is for the general case.
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
#include "event_groups.h"
#include "ShiftReg.h"

#define MAX_MESSAGE_SIZE 200 //maximum message size allowable, includes formatting
#define DEVICE_TABLE_SIZE 250

// messaging constants
static const uint8_t end_delimiter[3] = {0x03,0x03,0x03};

static uint8_t GLOBAL_DeviceID = 0x02; //device ID is set during initial startup
static uint8_t GLOBAL_Channel = 0x01; //channel number is set during initial startup
static uint8_t GLOBAL_DeviceType = 0x32; //this will be device type 0x32, generic light
static uint8_t GLOBAL_TableLength = 0; //increments as new entries are added to the table

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
#define mainINDOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainWLD_TASK_PRIORITY (tskIDLE_PRIORITY + 1)

// Task pointers

static void prvWiredInitTask ( void *parameters );
static void prvRS485OutTask ( void *parameters );
static void prvRS485InTask ( void *parameters );
static void prvLightOutTask ( void *parameters );
static void prvWLDTask ( void *parameters );

//Task handle
static TaskHandle_t RS485OutHandle = NULL;

//Mutexes

static SemaphoreHandle_t xUSART0_MUTEX = NULL;
static SemaphoreHandle_t xTABLE_MUTEX = NULL;
static SemaphoreHandle_t xDeviceBuffer_MUTEX = NULL;

//Semaphores

static SemaphoreHandle_t xPermission = NULL; //task notification replacement
static SemaphoreHandle_t xTXC = NULL;

//event groups

static EventGroupHandle_t xInit = NULL;

//stream handles

static StreamBufferHandle_t xRS485_in_Stream = NULL;
static StreamBufferHandle_t xRS485_out_Stream = NULL;
static MessageBufferHandle_t xRS485_out_Buffer = NULL;
static MessageBufferHandle_t xDevice_Buffer = NULL;

//queue handles

static QueueHandle_t xLIGHT_Queue = NULL;

//device table


int main(int argc, char** argv) {
    //clock is set by FreeRTOS
    //enable USART0 (RS485 USART)
    USART0_init();
    //set output mode for PD7 (485W) and ensure it is clear
    PORTA.DIRSET = PIN2_bm;
    PORTA.OUTCLR = PIN2_bm;
    //setup buffers and streams
    
    xRS485_in_Stream = xStreamBufferCreate(50,1); //50 bytes, triggers when a byte is added
    xRS485_out_Stream = xStreamBufferCreate(MAX_MESSAGE_SIZE, 1); //output buffer
    xRS485_out_Buffer = xMessageBufferCreate(400);
    xDevice_Buffer = xMessageBufferCreate(200);
    
    //setup Queues
    
    xLIGHT_Queue = xQueueCreate(3, 2 * sizeof(uint8_t)); // up to 3 Light Commands held
    
    //setup mutex(es)
    
    xUSART0_MUTEX = xSemaphoreCreateMutex();
    xTABLE_MUTEX = xSemaphoreCreateMutex();
    xDeviceBuffer_MUTEX = xSemaphoreCreateMutex();
    
    //setup semaphore
    
    xPermission = xSemaphoreCreateBinary();
    xTXC = xSemaphoreCreateBinary();
    
    //setup tasks
    
    xTaskCreate(prvWiredInitTask, "INIT", 300, NULL, mainWIREDINIT_TASK_PRIORITY, NULL);
    xTaskCreate(prvRS485OutTask, "RSOUT", 500, NULL, mainRS485OUT_TASK_PRIORITY, NULL);
    xTaskCreate(prvRS485InTask, "RSIN", 400, NULL, mainRS485IN_TASK_PRIORITY, NULL);
    xTaskCreate(prvLightOutTask, "INDOUT", 250, NULL, mainINDOUT_TASK_PRIORITY, NULL);
    xTaskCreate(prvWLDTask, "WBM", 600, NULL, mainWLD_TASK_PRIORITY, NULL);
    
    //setup event group
    
    xInit = xEventGroupCreate();
    
    //setup device ID and channel here, read shift registers and move into global variables
    /* removed for testing
    InitShiftIn(); //initialize shift register pins
    LTCHIn(); //latch input register
    ShiftIn(GLOBAL_Channel); //grab channel
    ShiftIn(GLOBAL_DeviceID); //grab DeviceID
    */
    //should now be done with shift registers
    
    //initialize device table to all 0s? Not needed
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
    //wait for the device to finish initializing.
    for(;;){
    //1. Take RS485 MUTEX
    xSemaphoreTake(xUSART0_MUTEX, portMAX_DELAY);
    //2. Start Flashing Indicators
    uint8_t lightsFlash[2] = {'Y', 0x2};
    xQueueSendToBack(xLIGHT_Queue, lightsFlash, portMAX_DELAY);
    /*//testing, feed the correct init message to the device.
    lightsFlash[0] = 0xaa;
    lightsFlash[1] = GLOBAL_DeviceID;
    vTaskDelay(500); //wait about half a second.
    xStreamBufferSend(xRS485_in_Stream, lightsFlash, 2, portMAX_DELAY);
    */
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
        if(ByteBuffer[0] == 0xAA) //start delimiter, next byte should be device ID during init
        {
            xStreamBufferReceive(xRS485_in_Stream, ByteBuffer, 1, portMAX_DELAY);
            if(ByteBuffer[0] == GLOBAL_DeviceID)// if this is the right device
            {
                received = 1;
            }
            if(xStreamBufferReceive(xRS485_in_Stream, ByteBuffer, 1, portMAX_DELAY == 0x03))
            {
            }
            //clear out the buffer before moving on
        }
        // just loop and discard anything else
    }
    //now we have been contacted by the master controller, we must reply
    ByteBuffer[0] = GLOBAL_DeviceID; //message prepared
    //load device ID into output buffer
    xStreamBufferSend(xRS485_out_Stream, ByteBuffer, 1, portMAX_DELAY);
    ByteBuffer[0] = 0x03;
    xStreamBufferSend(xRS485_out_Stream, ByteBuffer, 1, portMAX_DELAY);
    //start transmit mode
    vTaskDelay(1);
    PORTA.OUTSET = PIN2_bm;
    //send preamble to output buffer
    USART0.TXDATAL = 0xAA;
    //enable DRE interrupt
    USART0.CTRLA |= USART_DREIE_bm;
    //after it returns from the interrupt, wait for transmission to complete
    while(!(USART0.STATUS & USART_TXCIF_bm)); //just busy wait until done
    //now that transmission has finished, clear flag and set to receive mode
    USART0.STATUS |= USART_TXCIF_bm;
    PORTA.OUTCLR = PIN2_bm;
    //stop flashing lights
    lightsFlash[0] = 0;
    lightsFlash[1] = 0; //command 0, off
    xQueueSendToFront(xLIGHT_Queue ,lightsFlash, portMAX_DELAY);
    //enable TXCIE
    USART0.CTRLA |= USART_TXCIE_bm;
    //release MUTEX
    xSemaphoreGive(xUSART0_MUTEX);
    xEventGroupSetBits(xInit, 0x1); //set initialization flags
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
    /*first wakeup, wait for notification and send the join message*/
    //send network join message to RS485 output buffer
    xEventGroupWaitBits(xInit, 0x1, pdFALSE, pdFALSE, portMAX_DELAY); // wait for init
    // wait for notification
    xSemaphoreTake(xPermission, portMAX_DELAY);
    //acquire mutex
    xSemaphoreTake(xUSART0_MUTEX, portMAX_DELAY);
    vTaskDelay(15); //delay for communications?
    uint8_t StartMessage[11] = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xFF, 0xFF, GLOBAL_DeviceID, GLOBAL_Channel, GLOBAL_DeviceType};
    xStreamBufferSend(xRS485_out_Stream, StartMessage, 11, portMAX_DELAY);
    //tack on end delimiter
    xStreamBufferSend(xRS485_out_Stream, end_delimiter, 3, portMAX_DELAY);
    //enable transmitter
    PORTA.OUTSET = PIN2_bm; //set transmit mode
    //send preamble
    USART0.TXDATAL = 0xaa;
    //enable DRE interrupt
    USART0.CTRLA |= USART_DREIE_bm;
    //wait for TXcomplete notification
    xSemaphoreTake(xTXC, portMAX_DELAY);
    //return to receive mode
    PORTA.OUTCLR = PIN2_bm;
    //release USART MUTEX
    xSemaphoreGive(xUSART0_MUTEX);
    
    //now that this is done, we should be able to loop normally
    //load the output buffer with 8 byte address (all 0's)
    uint8_t pingres[11];
    for(uint8_t i = 0; i < 8; i++)
    pingres[i] = 0;
    pingres[8] = GLOBAL_DeviceID;
    pingres[9] = GLOBAL_Channel;
    pingres[10] = GLOBAL_DeviceType;
    uint8_t headerbuf[11];
    uint8_t buffer[MAX_MESSAGE_SIZE];
    for(;;){
    // wait for notification
    xSemaphoreTake(xPermission, portMAX_DELAY);
    //acquire mutex
    xSemaphoreTake(xUSART0_MUTEX, portMAX_DELAY);
    vTaskDelay(15); //delay for communications?
    //check for waiting output message
    uint8_t size = xMessageBufferReceive(xRS485_out_Buffer, buffer, MAX_MESSAGE_SIZE, 0);
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
            //load header with info
            headerbuf[0] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].XBeeADD[0];
            headerbuf[1] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].XBeeADD[1];
            headerbuf[2] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].XBeeADD[2];
            headerbuf[3] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].XBeeADD[3];
            headerbuf[4] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].XBeeADD[4];
            headerbuf[5] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].XBeeADD[5];
            headerbuf[6] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].XBeeADD[6];
            headerbuf[7] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].XBeeADD[7];
            headerbuf[8] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].WiredADD;
            headerbuf[9] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].Channel;
            headerbuf[10] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].Type;
            //don't need the table anymore, drop the MUTEX
            xSemaphoreGive(xTABLE_MUTEX);
            //next load the device type
            xStreamBufferSend(xRS485_out_Stream, headerbuf, 11, portMAX_DELAY);
            //next load the message (subtract last 2 bytes for intertask commands)
            xStreamBufferSend(xRS485_out_Stream, buffer, size - 2, portMAX_DELAY);
            //full message should be loaded into the output buffer now, prepare to start sending
            //tack on end delimiter
            xStreamBufferSend(xRS485_out_Stream, end_delimiter, 3, portMAX_DELAY);
            PORTA.OUTSET = PIN2_bm; //set transmit mode
            //send preamble to start transmisson
            USART0.TXDATAL = 0xAA;
            //enable DRE interrupt
            USART0.CTRLA |= USART_DREIE_bm;
            //wait for TXcomplete notification
            xSemaphoreTake(xTXC, portMAX_DELAY);
            //return to receive mode
            PORTA.OUTCLR = PIN2_bm;
            //release USART MUTEX
            xSemaphoreGive(xUSART0_MUTEX);
            //now complete message sending process, return to start of loop
            // wait for notification
            xSemaphoreTake(xPermission, portMAX_DELAY);
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
            //search table for devices marked relevant
            for(uint8_t count = 0; count < GLOBAL_TableLength; count++)
            {
                //grab table mutex
                xSemaphoreTake(xTABLE_MUTEX, portMAX_DELAY);
                if((GLOBAL_DEVICE_TABLE[count].Flags & 0x01 == 1) && (count == GLOBAL_TableLength - 1)) //relevant device and last in list
                {
                    //load header
                    headerbuf[0] = GLOBAL_DEVICE_TABLE[count].XBeeADD[0];
                    headerbuf[1] = GLOBAL_DEVICE_TABLE[count].XBeeADD[1];
                    headerbuf[2] = GLOBAL_DEVICE_TABLE[count].XBeeADD[2];
                    headerbuf[3] = GLOBAL_DEVICE_TABLE[count].XBeeADD[3];
                    headerbuf[4] = GLOBAL_DEVICE_TABLE[count].XBeeADD[4];
                    headerbuf[5] = GLOBAL_DEVICE_TABLE[count].XBeeADD[5];
                    headerbuf[6] = GLOBAL_DEVICE_TABLE[count].XBeeADD[6];
                    headerbuf[7] = GLOBAL_DEVICE_TABLE[count].XBeeADD[7];
                    headerbuf[8] = GLOBAL_DEVICE_TABLE[count].WiredADD;
                    headerbuf[9] = GLOBAL_DEVICE_TABLE[count].Channel;
                    headerbuf[10] = GLOBAL_DEVICE_TABLE[count].Type;
                    //don't need the table anymore, drop the MUTEX
                    xSemaphoreGive(xTABLE_MUTEX);
                    //load the output stream with the header
                    xStreamBufferSend(xRS485_out_Stream, headerbuf, 11, portMAX_DELAY);
                    //next load the message (subtract last 2 bytes for commands)
                    xStreamBufferSend(xRS485_out_Stream, buffer, size - 2, portMAX_DELAY);
                    //full message should be loaded into the output buffer now, prepare to start sending
                    //tack on end delimiter
                    xStreamBufferSend(xRS485_out_Stream, end_delimiter, 3, portMAX_DELAY);
                    PORTA.OUTSET = PIN2_bm; //set transmit mode
                    //send preamble to start transmission
                    USART0.TXDATAL = 0xAA;
                    //enable DRE interrupt
                    USART0.CTRLA |= USART_DREIE_bm;
                    //wait for TXcomplete notification
                    xSemaphoreTake(xTXC, portMAX_DELAY);
                    //return to receive mode
                    PORTA.OUTCLR = PIN2_bm;
                    //release USART MUTEX
                    xSemaphoreGive(xUSART0_MUTEX);
                }
                else if(GLOBAL_DEVICE_TABLE[count].Flags & 0x01 == 1) //relevant device
                {
                    //load header
                    headerbuf[0] = GLOBAL_DEVICE_TABLE[count].XBeeADD[0];
                    headerbuf[1] = GLOBAL_DEVICE_TABLE[count].XBeeADD[1];
                    headerbuf[2] = GLOBAL_DEVICE_TABLE[count].XBeeADD[2];
                    headerbuf[3] = GLOBAL_DEVICE_TABLE[count].XBeeADD[3];
                    headerbuf[4] = GLOBAL_DEVICE_TABLE[count].XBeeADD[4];
                    headerbuf[5] = GLOBAL_DEVICE_TABLE[count].XBeeADD[5];
                    headerbuf[6] = GLOBAL_DEVICE_TABLE[count].XBeeADD[6];
                    headerbuf[7] = GLOBAL_DEVICE_TABLE[count].XBeeADD[7];
                    headerbuf[8] = GLOBAL_DEVICE_TABLE[count].WiredADD;
                    headerbuf[9] = GLOBAL_DEVICE_TABLE[count].Channel;
                    headerbuf[10] = GLOBAL_DEVICE_TABLE[count].Type;
                    //don't need the table anymore, drop the MUTEX
                    xSemaphoreGive(xTABLE_MUTEX);
                    //load the output stream with the header
                    xStreamBufferSend(xRS485_out_Stream, headerbuf, 11, portMAX_DELAY);
                    //next load the message (subtract last 2 bytes for commands)
                    xStreamBufferSend(xRS485_out_Stream, buffer, size - 2, portMAX_DELAY);
                    //full message should be loaded into the output buffer now, prepare to start sending
                    //tack on end delimiter
                    xStreamBufferSend(xRS485_out_Stream, end_delimiter, 3, portMAX_DELAY);
                    PORTA.OUTSET = PIN2_bm; //set transmit mode
                    //send preamble to start transmission
                    USART0.TXDATAL = 0xAA;
                    //enable DRE interrupt
                    USART0.CTRLA |= USART_DREIE_bm;
                    //wait for TXcomplete notification
                    xSemaphoreTake(xTXC, portMAX_DELAY);
                    //return to receive mode
                    PORTA.OUTCLR = PIN2_bm;
                    //release USART MUTEX
                    xSemaphoreGive(xUSART0_MUTEX);
                    // wait for notification
                    xSemaphoreTake(xPermission, portMAX_DELAY);
                    //grab USART MUTEX
                    xSemaphoreTake(xUSART0_MUTEX, portMAX_DELAY);
                }
                else if(count == GLOBAL_TableLength - 1) //last in list, no relevant device found
                {
                    xSemaphoreGive(xUSART0_MUTEX);
                }
            }
        }
    }
    else // ping response, generic response is anything (or nothing in this case)
        {
            /* 1. assemble message in buffer as above
             * 2. perform sending process as above
             * 3. go back to start of task loop
             */
            
            //next load the device type
            xStreamBufferSend(xRS485_out_Stream, pingres, 11, portMAX_DELAY);
            //full message should be loaded into the output buffer now, prepare to start sending
            //tack on end delimiter
            xStreamBufferSend(xRS485_out_Stream, end_delimiter, 3, portMAX_DELAY);
            PORTA.OUTSET = PIN2_bm; //set transmit mode
            //send preamble to start transmission
            USART0.TXDATAL = 0xAA;
            //enable DRE interrupt
            USART0.CTRLA |= USART_DREIE_bm;
            //wait for TXcomplete notification
            xSemaphoreTake(xTXC, portMAX_DELAY);
            //return to receive mode
            PORTA.OUTCLR = PIN2_bm;
            //release USART MUTEX
            xSemaphoreGive(xUSART0_MUTEX);
        }
    }
}

static void prvRS485InTask(void * parameters)
{
    /* RS485 In Handler
     * 1. wait for something to come in on stream buffer
     * 2. assemble message in internal buffer, byte-by-byte
     * 3. check (in working on WBM code document)
     */
    uint8_t buffer[MAX_MESSAGE_SIZE];
    uint8_t byte_buffer[1];
    uint8_t length = 0;
    xEventGroupWaitBits(xInit, 0x1, pdFALSE, pdFALSE, portMAX_DELAY); // wait for init
    for(;;)
    {
    length = 0;
    //wait for something to come i
    xStreamBufferReceive(xRS485_in_Stream, byte_buffer, 1, portMAX_DELAY);
    if(byte_buffer[0] == 0xaa) //if not start delimiter, break somehow
    {
        //take MUTEX
        xSemaphoreTake(xUSART0_MUTEX, portMAX_DELAY);
        //loop and assemble until end delimiter received
        for(int i = 0; i < MAX_MESSAGE_SIZE; i++)
        {
            xStreamBufferReceive(xRS485_in_Stream, byte_buffer, 1, portMAX_DELAY);
            //check if start delimiter
            if(byte_buffer[0] == 0xaa)
            {i = MAX_MESSAGE_SIZE;}
            //check if delimiter(3 * 0x03 in a row)
                else if(byte_buffer[0] == 0x03)
            {
                buffer[i] = byte_buffer[0]; //add to buffer for now and increment length
                length++;
                i++;
                xStreamBufferReceive(xRS485_in_Stream, byte_buffer, 1, portMAX_DELAY);
                //2nd 0x03 check
                if(byte_buffer[0] == 0x03) //add to buffer for now and increment length
                {
                    buffer[i] = byte_buffer[0];
                    length++;
                    i++;
                    xStreamBufferReceive(xRS485_in_Stream, byte_buffer, 1, portMAX_DELAY);
                    //3rd 0x03 check
                    if(byte_buffer[0] == 0x03)
                    {// end of message, reduce length by 2 and end loop
                        i = MAX_MESSAGE_SIZE;
                        length = length - 2; //remove partial end delimiter
                    }
                    else
                    {
                        buffer[i] = byte_buffer[0];
                        length++;
                        i++;
                    }
                }
                else
                {
                    buffer[i] = byte_buffer[0];
                    length++;
                    i++;
                }
                        
            }
            else
            {
                buffer[i] = byte_buffer[0]; // add to message buffer
                length++; //increment length
            }
        }
        //assembled message is within the buffer, end delimiter received
        //release MUTEX and perform checks
        xSemaphoreGive(xUSART0_MUTEX);
        /* Check options:
         * first check for ping
         * then check for channel match and relevance
         */
        if(buffer[10] == 0x05) //if ping
        {
            if(buffer[8] == GLOBAL_DeviceID) //if right device
            {
                //send notification to the output task
                xSemaphoreGive(xPermission);
            }
        }
        else if(buffer[9] == GLOBAL_Channel) //if channel matches
        {
            /* channel check
             * 1. acquire table MUTEX
             * 2. check if wireless address 1st byte matches
             * 3. check if wired address matches
             * 4. check relevance bit
             * 5. perform actions based on that
             * 6. if no match found, create a new table entry at next empty spot
             */
            //acquire table MUTEX
            xSemaphoreTake(xTABLE_MUTEX, portMAX_DELAY);
            //loop through table entries
            uint8_t matched = 0;
            for(int pos = 0; pos < GLOBAL_TableLength; pos++)
            {
                if(GLOBAL_DEVICE_TABLE[pos].XBeeADD[0] == buffer[0]) //if first byte in wireless address matches, should be changed to check all
                    if(GLOBAL_DEVICE_TABLE[pos].WiredADD == buffer[8]) //if wired address matches
                        if((GLOBAL_DEVICE_TABLE[pos].Flags & 1) == 1) //if relevant
                        {
                            //assemble a new buffer containing only the message portion with the index entry as the first byte.
                            //message starts at byte 11
                            buffer[0] = pos;
                            buffer[1] = 0x00; //NULL padding to increase message length
                            //copy bytes back to start of buffer
                            for(int i = 11; i < length; i++)
                            {
                                buffer[i - 9] = buffer[i];
                            }
                            //release table MUTEX
                            xSemaphoreGive(xTABLE_MUTEX);
                            //reduce length by 9
                            length = length - 9;
                            //grab device buffer MUTEX
                            xSemaphoreTake(xDeviceBuffer_MUTEX, portMAX_DELAY);
                            //send to device buffer
                            xMessageBufferSend(xDevice_Buffer, buffer, length, portMAX_DELAY);
                            //release device MUTEX
                            xSemaphoreGive(xDeviceBuffer_MUTEX);
                            //set matched byte
                            matched = 1;
                            //now done with message processing
                        }
            }
            if(matched == 0)
            {
                /* if no match
                 * 1. add to end of table
                 * 2. increment table length
                 * 3. send check message with table index to device specific
                 * 4. release table mutex
                 * 5. wait 2 ms to allow device specific to make a decision
                 * 6. reacquire table mutex
                 * 7. check table relevance bit and either pass or discard
                 */
                //add to current end of table (add a check against max length at some point)
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[0] = buffer[0];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[1] = buffer[1];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[2] = buffer[2];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[3] = buffer[3];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[4] = buffer[4];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[5] = buffer[5];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[6] = buffer[6];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[7] = buffer[7];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].WiredADD = buffer[8];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].Channel = buffer[9];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].Type = buffer[10];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].Flags = 0;
                //increment table length
                GLOBAL_TableLength++;
                //release table MUTEX
                xSemaphoreGive(xTABLE_MUTEX);
                //grab device buffer MUTEX
                xSemaphoreTake(xDeviceBuffer_MUTEX, portMAX_DELAY);
                //check message will be defined as {0x05, index}
                uint8_t check[2] = {0x05, GLOBAL_TableLength - 1};
                //send check message to device buffer
                xMessageBufferSend(xDevice_Buffer, check, 2, portMAX_DELAY);
                //release device MUTEX
                xSemaphoreGive(xDeviceBuffer_MUTEX);
                //wait 5ms to allow device specific some time to process
                vTaskDelay(5 / portTICK_PERIOD_MS);
                //reacquire table mutex
                xSemaphoreTake(xTABLE_MUTEX, portMAX_DELAY);
                //check relevance bit
                if(GLOBAL_DEVICE_TABLE[GLOBAL_TableLength-1].Flags & 1)
                {   
                    //assemble a new buffer containing only the message portion with the index entry as the first byte.
                    //message starts at byte 11
                    buffer[0] = GLOBAL_TableLength-1;
                    buffer[1] = 0x00; //NULL padding to increase message length
                    //copy bytes back to start of buffer
                    for(int i = 11; i < length; i++)
                    {
                        buffer[i - 9] = buffer[i];
                    }
                    //reduce length by 9
                    length = length - 9;
                    //pass on message
                    //grab device buffer MUTEX
                    xSemaphoreTake(xDeviceBuffer_MUTEX, portMAX_DELAY);
                    //send to device buffer
                    xMessageBufferSend(xDevice_Buffer, buffer, length, portMAX_DELAY);
                    //release device MUTEX
                    xSemaphoreGive(xDeviceBuffer_MUTEX);
                }
                //return MUTEX
                xSemaphoreGive(xTABLE_MUTEX);
            }
        }
        else if(buffer[9] == 0xff) //special channel check for broadcast devices
        {
            /* always pass message, but also include in device table and ensure
             * that the device specific knows that it is there so it can store in
             * it's special table
             */
            
        }
    }
    
    }
}

static void prvLightOutTask(void * parameters)
{
    // first I will initialize the pins as outputs
    PORTC.DIRSET = PIN2_bm | PIN3_bm;
    PORTD.DIRSET = PIN0_bm | PIN1_bm;
    
    /* Indicator out loop:
     * 1. wait for message on input queue
     * 2. process message
     * 3. turn indicators on, off, or blink
     */
    uint8_t output = 0; //initialize as none
    uint8_t blink = 0; //output flash or solid 
    uint8_t received[2]; // receiver buffer
    for(;;)
    {
        //first, check if commands have come in
        //250 tick delay (250ms)
        xQueueReceive(xLIGHT_Queue, received, 250);
        output = received[0];
        blink = received[1];
        //after processing commands, switch light state based on the commands
        switch(output) //Turn lights on or off
        {
            case 0x0: //light off
                PORTC.OUTCLR = PIN2_bm | PIN3_bm;
                PORTD.OUTCLR = PIN0_bm | PIN1_bm;
                break;
            case 'G': //Green
                PORTC.OUTCLR = PIN2_bm;
                PORTD.OUTCLR = PIN0_bm | PIN1_bm;
                switch(blink)
                {
                    case 0x1: //solid
                        PORTC.OUTSET = PIN3_bm;
                        break;
                    case 0x2: //blink
                        PORTC.OUTTGL = PIN3_bm;
                        break;
                }
                break;
            case 'R': //Red
                PORTC.OUTCLR = PIN3_bm;
                PORTD.OUTCLR = PIN0_bm | PIN1_bm;
                switch(blink)
                {
                    case 0x1: //solid
                        PORTC.OUTSET = PIN2_bm;
                        break;
                    case 0x2: //blink
                        PORTC.OUTTGL = PIN2_bm;
                        break;
                }
                break;
            case 'Y': //Yellow
                PORTC.OUTCLR = PIN3_bm | PIN2_bm;
                PORTD.OUTCLR = PIN0_bm;
                switch(blink)
                {
                    case 0x1: //solid
                        PORTD.OUTSET = PIN1_bm;
                        break;
                    case 0x2: //blink
                        PORTD.OUTTGL = PIN1_bm;
                        break;
                }
                break;
            case 'B': //Blue
                PORTC.OUTCLR = PIN2_bm | PIN3_bm;
                PORTD.OUTCLR = PIN1_bm;
                switch(blink)
                {
                    case 0x1: //solid
                        PORTD.OUTSET = PIN0_bm;
                        break;
                    case 0x2: //blink
                        PORTD.OUTTGL = PIN0_bm;
                        break;
                }
                break;
        }
    }
}

static void prvWLDTask(void * parameters)
{
    /* Wired Light Driver:
     * 1. check for input (blocks up to 50 ticks?)
     * 2. perform input checking
     * 3. turn on appropriate light
     * 4. reply to light being turned on
     */
    uint8_t colour_light = 0;// 0 = off, used to track light colour
    uint8_t inlen = 0; //input length tracking
    uint8_t lightbuffer[2]; //buffer for commands to indicators
    uint8_t buffer[MAX_MESSAGE_SIZE]; //message buffer
    //uint8_t lights[20]; //one controller can track up to 20 lights?
    uint8_t lightnum = 0; //keep track of how many lights are controlled
    uint8_t lightrem = 0; //track how many lights need to be confirmed
    uint8_t controllers[20]; //when implemented
    //uint8_t broadcast[20]; //20 broadcast channel devices
    //uint8_t menus[20]; //up to 20 menus
    for(;;)
    {
        //1. wait up to 50 ticks for input, need to grab MUTEX?
        //grab device buffer MUTEX
        inlen = 0;
        xSemaphoreTake(xDeviceBuffer_MUTEX, portMAX_DELAY);
        //keep track of length as well
        inlen = xMessageBufferReceive(xDevice_Buffer, buffer, MAX_MESSAGE_SIZE, 50);
        //release device buffer MUTEX
        xSemaphoreGive(xDeviceBuffer_MUTEX);
        //2. check input
        switch (inlen)
        {
            case 0: //no message
                break;
            case 2: //intertask message
                switch(buffer[0])
                {
                    case 0x05: //check device table
                        //device table processing here, check device type and mark relevance for lights only for now
                        //add other device types to relevant tables for quicker access in the future
                        //acquire table MUTEX
                        xSemaphoreTake(xTABLE_MUTEX, portMAX_DELAY);
                        //check on requested table entry's device type
                        switch(GLOBAL_DEVICE_TABLE[buffer[1]].Type)
                        {
                            case 0x31: //generic light controller
                                //mark as relevant
                                GLOBAL_DEVICE_TABLE[buffer[1]].Flags = 0x1;
                                //add index to controller table
                                controllers[lightnum] = buffer[1];
                                //increment lightnum count
                                lightnum++;
                            break;
                        }
                        //release table MUTEX
                        xSemaphoreGive(xTABLE_MUTEX);
                        break;
                }
            case 3: //length of 3 indicates from controller or other device (just controller for now)
                //no confirmation from light just yet, that will come after some design work on Friday
                //just change colour and echo back to controllers (relevant devices)
                switch(buffer[2])
                {
                    case 'B': //Blue (flash implied)
                        lightbuffer[0] = buffer[2];
                        lightbuffer[1] = 0x2;
                        xQueueSend(xLIGHT_Queue, lightbuffer, portMAX_DELAY);
                        break;
                    case 'G': //Green (not flash)
                        lightbuffer[0] = buffer[2];
                        lightbuffer[1] = 0x1;
                        xQueueSend(xLIGHT_Queue, lightbuffer, portMAX_DELAY);
                        break;
                    case 'Y': //Yellow (not flash)
                        lightbuffer[0] = buffer[2];
                        lightbuffer[1] = 0x1;
                        xQueueSend(xLIGHT_Queue, lightbuffer, portMAX_DELAY);
                        break;
                    case 'R': //Red (not flash)
                        lightbuffer[0] = buffer[2];
                        lightbuffer[1] = 0x1;
                        xQueueSend(xLIGHT_Queue, lightbuffer, portMAX_DELAY);
                        break;
                }
                break;
        }
    }
}

ISR(USART0_RXC_vect)
{
    /* Receive complete interrupt
     * move received byte into byte buffer for RS485 in task
     */
    uint8_t buf[1];
    buf[0] = USART0.RXDATAL;
    xMessageBufferSendFromISR(xRS485_in_Stream, buf, 1, NULL);
}
ISR(USART0_DRE_vect)
{
    /* Data Register empty Interrupt
     * 1. pull from output stream buffer and put in TX register until clear
     * 2. disable interrupt
     */
    uint8_t buf[1];
    if(xStreamBufferReceiveFromISR(xRS485_out_Stream, buf, 1, NULL) == 0) //if end of message
        USART0.CTRLA &= ~USART_DREIE_bm; //disable interrupt
    else
        USART0.TXDATAL = buf[0];
}
ISR(USART0_TXC_vect)
{
    /* Transmission complete interrupts
     * 1. set semaphore
     * 2. clear interrupt flag
     */
    xSemaphoreGive(xTXC); //send notification to output task
    USART0.STATUS |= USART_TXCIF_bm; //clear flag by writing a 1 to it
}