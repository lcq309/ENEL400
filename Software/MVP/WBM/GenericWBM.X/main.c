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
#include "ShiftReg.h"

#define MAX_MESSAGE_SIZE 200 //maximum message size allowable, includes formatting
#define DEVICE_TABLE_SIZE 250

static uint8_t GLOBAL_DeviceID = 0x01; //device ID is set during initial startup
static uint8_t GLOBAL_Channel = 0x01; //channel number is set during initial startup
static uint8_t GLOBAL_DeviceType = 0x31; //this will be device type 0x31, generic controller
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
#define mainPBIN_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainINDOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainWBM_TASK_PRIORITY (tskIDLE_PRIORITY + 1)

// Task pointers

static void prvWiredInitTask ( void *parameters );
static void prvRS485OutTask ( void *parameters );
static void prvRS485InTask ( void *parameters );
static void prvPbInTask ( void *parameters );
static void prvIndOutTask ( void *parameters );
static void prvWBMTask ( void *parameters );

//Task handle
static TaskHandle_t RS485OutHandle = NULL;

//Mutexes

static SemaphoreHandle_t xUSART0_MUTEX = NULL;
static SemaphoreHandle_t xTABLE_MUTEX = NULL;
static SemaphoreHandle_t xDeviceBuffer_MUTEX = NULL;

//Semaphores

static SemaphoreHandle_t xInit = NULL;

//stream handles

static StreamBufferHandle_t xRS485_in_Stream = NULL;
static StreamBufferHandle_t xRS485_out_Stream = NULL;
static MessageBufferHandle_t xRS485_out_Buffer = NULL;
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
    
    xRS485_in_Stream = xStreamBufferCreate(50,1); //50 bytes, triggers when a byte is added
    xRS485_out_Stream = xStreamBufferCreate(MAX_MESSAGE_SIZE, 1); //output buffer
    xRS485_out_Buffer = xMessageBufferCreate(400);
    xDevice_Buffer = xMessageBufferCreate(200);
    
    //setup Queues
    
    xPB_Queue = xQueueCreate(3, sizeof(uint8_t)); //up to 3 button presses held
    xIND_Queue = xQueueCreate(3, 2 * sizeof(uint8_t)); // up to 3 Indicator Commands held
    
    //setup mutex(es)
    
    xUSART0_MUTEX = xSemaphoreCreateMutex();
    xTABLE_MUTEX = xSemaphoreCreateMutex();
    xDeviceBuffer_MUTEX = xSemaphoreCreateMutex();
    
    //setup semaphore
    
    xInit = xSemaphoreCreateBinary();
    
    //setup tasks
    
    xTaskCreate(prvWiredInitTask, "INIT", 300, NULL, mainWIREDINIT_TASK_PRIORITY, NULL);
    xTaskCreate(prvRS485OutTask, "RSOUT", 500, NULL, mainRS485OUT_TASK_PRIORITY, RS485OutHandle);
    xTaskCreate(prvRS485InTask, "RSIN", 400, NULL, mainRS485IN_TASK_PRIORITY, NULL);
    xTaskCreate(prvPbInTask, "PBIN", 250, NULL, mainPBIN_TASK_PRIORITY, NULL);
    xTaskCreate(prvIndOutTask, "INDOUT", 250, NULL, mainINDOUT_TASK_PRIORITY, NULL);
    xTaskCreate(prvWBMTask, "WBM", 600, NULL, mainWBM_TASK_PRIORITY, NULL);
    
    //setup device ID and channel here, read shift registers and move into global variables
    /*
    InitShiftIn(); //initialize shift register pins
    LTCHIn(); //latch input register
    ShiftIn(GLOBAL_Channel); //grab channel
    ShiftIn(GLOBAL_DeviceID); //grab DeviceID
    //should now be done with shift registers
    */
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
    for(;;){
    //1. Take RS485 MUTEX
    xSemaphoreTake(xUSART0_MUTEX, portMAX_DELAY);
    //2. Start Flashing Indicators
    uint8_t lightsFlash[2] = {0xFF, 0x2};
    xQueueSendToBack(xIND_Queue, lightsFlash, portMAX_DELAY);
    xSemaphoreTake(xInit, 0);
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
    USART0.TXDATAL = 0xaa;
    //enable DRE interrupt
    USART0.CTRLA |= USART_DREIE_bm;
    //after it returns from the interrupt, wait for transmission to complete
    while(!(USART0.STATUS & USART_TXCIF_bm)); //just busy wait until done
    //now that transmission has finished, clear flag and set to receive mode
    USART0.STATUS |= USART_TXCIF_bm;
    PORTD.OUTCLR = PIN7_bm;
    //stop flashing lights
    lightsFlash[0] = 0xff;
    lightsFlash[1] = 0; //command 0, off
    xQueueSendToFront(xIND_Queue ,lightsFlash, portMAX_DELAY);
    //enable TXCIE
    USART0.CTRLA |= USART_TXCIE_bm;
    //release MUTEX
    xSemaphoreGive(xUSART0_MUTEX);
    xSemaphoreGive(xInit);
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
    
    // wait for notification
    ulTaskNotifyTakeIndexed(1, pdTRUE, portMAX_DELAY);
    //acquire mutex
    xSemaphoreTake(xUSART0_MUTEX, portMAX_DELAY);
    uint8_t StartMessage[11] = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xFF, 0xFF, GLOBAL_DeviceID, GLOBAL_Channel, GLOBAL_DeviceType};
    xMessageBufferSend(xRS485_out_Buffer, StartMessage, 11, portMAX_DELAY);
    //enable transmitter
    PORTD.OUTSET = PIN7_bm; //set transmit mode
    //send preamble
    USART0.TXDATAL = 0xaa;
    //enable DRE interrupt
    USART0.CTRLA |= USART_DREIE_bm;
    //wait for TXcomplete notification
    ulTaskNotifyTakeIndexed(1, pdTRUE, portMAX_DELAY);
    //return to receive mode
    PORTD.OUTCLR = PIN7_bm;
    //release USART MUTEX
    xSemaphoreGive(xUSART0_MUTEX);
    
    //now that this is done, we should be able to loop normally
    

    for(;;){
    uint8_t buffer[MAX_MESSAGE_SIZE];
    // wait for notification
    ulTaskNotifyTakeIndexed(1, pdTRUE, portMAX_DELAY);
    //acquire mutex
    xSemaphoreTake(xUSART0_MUTEX, portMAX_DELAY);
    //check for waiting output message
    uint8_t size = xMessageBufferReceive(xRS485_out_Buffer, buffer, MAX_MESSAGE_SIZE, 10);
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
            ulTaskNotifyTakeIndexed(1, pdTRUE, portMAX_DELAY);
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
            for(uint8_t count = 0; count < GLOBAL_TableLength; count++)
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
                    ulTaskNotifyTakeIndexed(1, pdTRUE, portMAX_DELAY);
                    //return to receive mode
                    PORTD.OUTCLR = PIN7_bm;
                    //release USART MUTEX
                    xSemaphoreGive(xUSART0_MUTEX);
                    //now complete message sending process, wait for the next opportunity
                    ulTaskNotifyTakeIndexed(1, pdTRUE, portMAX_DELAY);
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
            ulTaskNotifyTakeIndexed(1, pdTRUE, portMAX_DELAY);
            //return to receive mode
            PORTD.OUTCLR = PIN7_bm;
            //release USART MUTEX
            xSemaphoreGive(xUSART0_MUTEX);
        }
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
    for(;;)
    {
    length = 0;
    //wait for something to come in
    xStreamBufferReceive(xRS485_in_Stream, byte_buffer, 1, portMAX_DELAY);
    if(byte_buffer[0] == 0xAA) //if not start delimiter, break somehow
    {
        //take MUTEX
        xSemaphoreTake(xUSART0_MUTEX, portMAX_DELAY);
        //loop and assemble until end delimiter received
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
                xTaskNotifyGiveIndexed(RS485OutHandle, 1);
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
                        if(GLOBAL_DEVICE_TABLE[pos].Flags & 1 == 1) //if relevant
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
                            //release table MUTEX
                            xSemaphoreGive(xTABLE_MUTEX);
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
                //grab device buffer MUTEX
                xSemaphoreTake(xDeviceBuffer_MUTEX, portMAX_DELAY);
                //check message will be defined as {0x05, index}
                uint8_t check[2] = {0x05, GLOBAL_TableLength - 1};
                //send check message to device buffer
                xMessageBufferSend(xDevice_Buffer, check, 2, portMAX_DELAY);
                //release device MUTEX
                xSemaphoreGive(xDeviceBuffer_MUTEX);
                //wait 2ms to allow device specific some time to process
                vTaskDelay(2 / portTICK_PERIOD_MS);
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

static void prvPbInTask(void * parameters)
{
    /* Pushbutton In Task
     * Takes input from the pushbutton interrupts, keeps track of last button to
     * provide software debouncing (probably not used so much on the lap count driver)
     * 1. wait for something to come in from the queue (pushbutton interrupts)
     * 2. acquire device specific MUTEX
     * 3. pass to device specific
     */
    //I will setup the interrupts and inputs here
    //I will start by ensuring all pins are inputs
    PORTD.DIRCLR = PIN6_bm | PIN5_bm | PIN3_bm | PIN2_bm;
    PORTC.DIRCLR = PIN3_bm;
    //Then I will set up the multi-configure register for port D.
    PORTD.PINCONFIG = 0x3 | PORT_PULLUPEN_bm; //enable falling edge interrupt and pullup
    //update configuration for selected pins
    PORTD.PINCTRLUPD = PIN6_bm | PIN5_bm | PIN3_bm | PIN2_bm;
    //now the same thing for PORTC
    PORTC.PIN3CTRL = 0x3 | PORT_PULLUPEN_bm; //enable falling edge interrupt and pullup
    //now interrupts should be enabled, I will have to implement the routines below
    //initialization complete, enter looping section.
    uint8_t input[1];
    for(;;)
    {
        //wait for something to come in from the queue
        xQueueReceive(xPB_Queue, input, portMAX_DELAY);
        //add a messaging byte to the front, 0x04 in this case
        //device specific needs to check for a two-byte message and react according to the first byte of the message
        uint8_t output[2];
        output[0] = 0x04;
        output[1] = input[0];
        //grab device buffer MUTEX
        xSemaphoreTake(xDeviceBuffer_MUTEX, portMAX_DELAY);
        //send to device buffer
        xMessageBufferSend(xDevice_Buffer, output, 2, portMAX_DELAY);
        //release device MUTEX
        xSemaphoreGive(xDeviceBuffer_MUTEX);
    }
}

static void prvIndOutTask(void * parameters)
{
    // first I will initialize the pins as outputs
    PORTA.DIRSET = PIN7_bm;
    PORTC.DIRSET = PIN0_bm | PIN1_bm;
    
    /* Indicator out loop:
     * 1. wait for message on input queue
     * 2. process message
     * 3. turn indicators on, off, or blink
     */
    uint8_t I1, I2, I3; //indicator state buffers
    I1 = 0; I2 = 0; I3 = 0; //initialize each to zero
    uint8_t received[2]; // receiver buffer
    for(;;)
    {
        //first, check if commands have come in
        //250 tick delay (250ms)
        xQueueReceive(xIND_Queue, received, 250);
        //process commands and set the indicator buffers
        switch(received[0]) //first check is the intended target
        {
            case 0x0: //do nothing/no target
                break;
            case 0x1: //Indicator 1
                I1 = received[1];
                break;
            case 0x2: //Indicator 2
                I2 = received[1];
                break;
            case 0x3: //Indicator 3
                I3 = received[1];
                break;
            case 0xff: //All indicators
                I1 = received[1];
                I2 = received[1];
                I3 = received[1];
                break;
        }
        //after processing commands, switch light state based on the commands
        switch(I1) //Indicator 1
        {
            case 0x0: //light off
                PORTC.OUTCLR = PIN1_bm;
                break;
            case 0x1: //light on
                PORTC.OUTSET = PIN1_bm;
                break;
            case 0x2: //blink
                PORTC.OUTTGL = PIN1_bm;
                break;
        }
        switch(I2) //Indicator 2
        {
            case 0x0: //light off
                PORTC.OUTCLR = PIN0_bm;
                break;
            case 0x1: //light on
                PORTC.OUTSET = PIN0_bm;
                break;
            case 0x2: //blink
                PORTC.OUTTGL = PIN0_bm;
                break;
        }
        switch(I3) //Indicator 3 
        {
            case 0x0: //light off
                PORTA.OUTCLR = PIN7_bm;
                break;
            case 0x1: //light on
                PORTA.OUTSET = PIN7_bm;
                break;
            case 0x2: //blink
                PORTA.OUTTGL = PIN7_bm;
                break;
        }
                
    }
}

static void prvWBMTask(void * parameters)
{
    /* Wired Button Module:
     * 1. check for input (blocks up to 50 ticks?)
     * 2. perform input checking
     * 3. if no actable input, and task is ready, go back to waiting for input
     * 4. if no actable input, and task is waiting for colour change, check on resend timer state
     *    -if it is time to resend, then check table for unconfirmed lights and send a message to them
     *    -if not time to resend, go back to waiting
     * 5. if actable input, perform action
     *  - colour change, start blinking both lights and send messages out
     *  - incoming light confirmation signal, compare colour and either lockout or confirm
     */
    //uint8_t task_state = 0; //0 = uninitialized
    //uint8_t lockout = 0; //0 = not locked
    uint8_t colour_track = 0;// 0 = off, used to track colour requested
    uint8_t colour_light = 0;// 0 = off, used to track light colour
    uint8_t inlen = 0; //input length tracking
    uint8_t indbuffer[2]; //buffer for commands to indicators
    uint8_t buffer[MAX_MESSAGE_SIZE]; //message buffer
    uint8_t lights[20]; //one controller can track up to 20 lights?
    uint8_t lightnum = 1; //keep track of how many lights are controlled
    uint8_t lightrem = 0; //track how many lights need to be confirmed
    //uint8_t controllers[20]; //when implemented
    //uint8_t broadcast[20]; //20 broadcast channel devices
    //uint8_t menus[20]; //up to 20 menus
    
    xSemaphoreTake(xInit, portMAX_DELAY); //take when initialized
    for(;;)
    {
        //1. wait up to 50 ticks for input, need to grab MUTEX?
        //grab device buffer MUTEX
        xSemaphoreTake(xDeviceBuffer_MUTEX, portMAX_DELAY);
        //keep track of length as well
        inlen = xMessageBufferReceive(xDevice_Buffer, buffer, MAX_MESSAGE_SIZE, 250);
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
                            case 0x32: //generic light
                                //mark as relevant
                                GLOBAL_DEVICE_TABLE[buffer[1]].Flags = 0x1;
                                //add index to light table
                                lights[lightnum] = buffer[1];
                                //increment lightnum count
                                lightnum++;
                            break;
                        }
                        //release table MUTEX
                        xSemaphoreGive(xTABLE_MUTEX);
                        break;
                    case 0x04:    //button press
                        switch(buffer[1])
                        {
                            case 0x1: //button 1 (call this blue for now)
                                colour_track = 'B'; // blue lights
                                if(colour_track != colour_light)
                                lightrem = lightnum;
                                break;
                            case 0x2: //button 2 (call this green for now)
                                colour_track = 'G';
                                if(colour_track != colour_light)
                                lightrem = lightnum;
                                break;
                            case 0x3: //button 3 (call this yellow for now)
                                colour_track = 'Y';
                                if(colour_track != colour_light)
                                lightrem = lightnum;
                                break;
                        }
                        break;
                }
            case 3: //length of 3 indicates from light or other device (just lights for now)
                //check index entry of light, mark confirmation bit if colour matches
                //check colour and compare against colour track variable
                if(buffer[2] == colour_track)
                {
                    //mark confirmation bit, byte 0 should be index.
                    //acquire table MUTEX
                    xSemaphoreTake(xTABLE_MUTEX, portMAX_DELAY);
                    //bit 1 will be used as a confirmation for now
                    GLOBAL_DEVICE_TABLE[buffer[0]].Flags |= 0x2;
                    //release table MUTEX
                    xSemaphoreGive(xTABLE_MUTEX);
                    //subtract one from remaining lights to confirm
                    lightrem--;
                }
                else //error or state change? not implemented yet
                {}
                break;
        }
        /* Testing section
         * very basic test, just put out a message of the currently requested colour, flash the current indicator and the new one
         * reset the confirmation bit of the current light, then once the colour is confirmed, turn on the new indicator and turn off the flashing one
         * acts if colour_track is different from colour_light
         * 1. flash indicators
         * 2. reset confirmation bit of lights
         * 3. light_rem = light_num
         * 4. send the colour to the output task
         * 5. release table mutex
         */
        
        
        /* change colour check section:
         * check if there is a colour change
         * if there is a colour change, flash both lights, transmit colour change message
         */
        if(colour_light != colour_track)
        {
            //change light colours
            indbuffer[1] = 2; //flashing
            switch(colour_light)
            {
                case 'B':
                    indbuffer[0] = 1; //indicator 1
                    break;
                case 'G':
                    indbuffer[0] = 2; //indicator 2
                    break;
                case 'Y':
                    indbuffer[0] = 3; //indicator 3
                    break;
                default:
                    indbuffer[0] = 0; //no indicator
            }
            xQueueSendToBack(xIND_Queue, indbuffer, portMAX_DELAY);
            switch(colour_track)
            {
                case 'B':
                    indbuffer[0] = 1; //indicator 1
                    break;
                case 'G':
                    indbuffer[0] = 2; //indicator 2
                    break;
                case 'Y':
                    indbuffer[0] = 3; //indicator 3
                    break;
                default:
                    indbuffer[0] = 0; //no indicator
            }
            xQueueSendToBack(xIND_Queue, indbuffer, portMAX_DELAY);
            //lights should now be flashing
            //send colour change message to the RS485_output
            //send to relevant devices for now
            //last two bytes of message need to be 0x0401
            buffer[0] = colour_track;
            buffer[1] = 0x04;
            buffer[2] = 0x01;
            xMessageBufferSend(xRS485_out_Buffer, buffer, 3, portMAX_DELAY);
        }
        /* colour confirmation section
         * once lightrem = 0, set light_colour to colour_track
         * turn off all indicators and turn on the correct one
         */
        if (lightrem == 0)
        {
            colour_light = colour_track;
            indbuffer[0] = 0xff;
            indbuffer[1] = 0;
            xQueueSendToBack(xIND_Queue, indbuffer, portMAX_DELAY);
            indbuffer[1] = 1;
            switch(colour_light)
            {
                case 'B':
                    indbuffer[0] = 1; //indicator 1
                    break;
                case 'G':
                    indbuffer[0] = 2; //indicator 2
                    break;
                case 'Y':
                    indbuffer[0] = 3; //indicator 3
                    break;
                default:
                    indbuffer[0] = 0; //no indicator
            }
            xQueueSendToBack(xIND_Queue, indbuffer, portMAX_DELAY);
        }
        /* message processing section complete:
         * confirmation check section
         * not yet implemented, since this is the most basic case for testing use
         * just send a message for the correct light colour if it has changed
         * (i.e, not confirmed)
         */
        
    }
}

ISR(PORTD_PORT_vect)
{
    /* PORTD interrupt:
     * 1. check which line the interrupt is on
     * 2. clear the interrupt
     * 3. send the button number to the button task
     */
    //1. check which pin the interrupt is on
    uint8_t pb[1] = {0};
    switch(PORTD.INTFLAGS)
    {
        case PIN6_bm: //button 1
            PORTD.INTFLAGS = PIN6_bm; //reset interrupt
            pb[0] = 0x01;
            break;
        case PIN5_bm: //button 2
            PORTD.INTFLAGS = PIN5_bm; //reset interrupt
            pb[0] = 0x02;
            break;
        case PIN3_bm: //button 3
            PORTD.INTFLAGS = PIN3_bm; //reset interrupt
            pb[0] = 0x03;
            break;
        case PIN2_bm: //button 4
            PORTD.INTFLAGS = PIN2_bm; //reset interrupt
            pb[0] = 0x04;
    }
    xQueueSendToFrontFromISR(xPB_Queue, pb, NULL);
}

ISR(PORTC_PORT_vect)
{
    uint8_t pb[1] = {0x05};
    PORTC.INTFLAGS = PIN3_bm;
    xQueueSendToFrontFromISR(xPB_Queue, pb, NULL);
}

ISR(USART0_RXC_vect)
{
    /* Receive complete interrupt
     * move received byte into byte buffer for RS485 in task
     */
    xMessageBufferSendFromISR(xRS485_in_Stream, USART0.RXDATAL, 1, NULL);
}
ISR(USART0_DRE_vect)
{
    /* Data Register empty Interrupt
     * 1. pull from output stream buffer and put in TX register until clear
     * 2. send end delimiter
     * 3. disable interrupt after loading end delimiter
     */
    uint8_t buf[1];
    if(xStreamBufferReceiveFromISR(xRS485_out_Stream, buf, 1, NULL) == 0) //if end of message
    {
        USART0.TXDATAL = 0x03; //add end delimiter on end of message
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
     */
    xTaskNotifyGiveIndexed(RS485OutHandle, 1); //send notification to output task
    USART0.STATUS |= USART_TXCIF_bm; //clear flag by writing a 1 to it
}