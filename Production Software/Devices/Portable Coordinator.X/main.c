/* 
 * Portable Coordinator
 * Author:  Michael King
 * 
 * Created on August 9, 2024
 * 
 * This is meant to be a portable wired network coordinator device, this device is responsible
 * for creating and driving the wired network.
 * this is quite different from the function of other devices on the wired network,
 * so the networking code for this device is unique and separate from all other devices.
 * It needs to check battery level, control a status light, and it does not have
 * a menu. it needs to keep track of menus on the network to send it's battery messages.
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
#include "ADC.h"
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

//timer handles
TimerHandle_t xBATTTimer;
TimerHandle_t xINDTimer;

//timer globals
uint8_t xBATTTimerSet = 0;
uint8_t xINDTimerSet;

//define priorities

#define mainWIREDINIT_TASK_PRIORITY (tskIDLE_PRIORITY + 4)
#define mainOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainIN_TASK_PRIORITY (tskIDLE_PRIORITY + 3)
#define mainROUNDROBIN_TASK_PRIORITY (tskIDLE_PRIORITY + 1)
#define mainINDOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainSTAT_TASK_PRIORITY (tskIDLE_PRIORITY + 3)


QueueHandle_t xIND_Queue;
QueueHandle_t xDeviceIN_Queue;
QueueHandle_t xSTAT_Queue;
    
//helper function prototype
void RS485TR(uint8_t dir);
void VoltageCheck(void);

void dsioStatOn(void);
void dsioStatOff(void);
void dsioStatTGL(void);

//timer callback functions
void vINDTimerFunc( TimerHandle_t xTimer ); 
void vBattCheckTimerFunc( TimerHandle_t xTimer );

//Event Groups
EventGroupHandle_t xEventInit;

//task pointers
void prvWiredInitTask( void * parameters );
void prv485OUTTask( void * parameters );
void prv485INTask( void * parameters );
void prvRoundRobinTask( void * parameters );

//wireless tasks
void prvXBEEOUTTask( void * parameters );
void prvXBEEINTask( void * parameters );

//status tasks
void dsioOUTTask( void * parameters );
void dsIOSTATUS( void * parameters );

//Queue handles

QueueHandle_t xDeviceIN_Queue; //check replies from the menu devices
QueueHandle_t xSTAT_Queue; //from the battery check register

//stream handles

//wired
static StreamBufferHandle_t xRS485_in_Stream = NULL;
static StreamBufferHandle_t xRS485_out_Stream = NULL;
static MessageBufferHandle_t xRS485_out_Buffer = NULL;
static MessageBufferHandle_t xRoundRobin_Buffer = NULL;

//wireless
static StreamBufferHandle_t xXBEE_in_Stream = NULL;
static StreamBufferHandle_t xXBEE_out_Stream = NULL;
static MessageBufferHandle_t xXBEE_out_Buffer = NULL;

//Mutexes
static SemaphoreHandle_t xUSART0_MUTEX = NULL;
static SemaphoreHandle_t xRoundRobin_MUTEX = NULL;
static SemaphoreHandle_t x485_MUTEX = NULL;
static SemaphoreHandle_t xXBEE_MUTEX = NULL;

//Semaphores
static SemaphoreHandle_t xRS485TX_SEM = NULL;
static SemaphoreHandle_t xXBEETX_SEM = NULL;
SemaphoreHandle_t xBattCheckTrig;

//Device Table
static uint8_t GLOBAL_DEVICE_TABLE[LIST_LENGTH];
static uint8_t table_length = 0; //keep track of how many devices initialize

int main(int argc, char** argv) {
    
    //set clock speed (this is here because it is most important for communications)
    
    _PROTECTED_WRITE(CLKCTRL.OSCHFCTRLA, CLKCTRL_FRQSEL_24M_gc);
    
    //setup tasks
    
    xTaskCreate(prvWiredInitTask, "INIT", 300, NULL, mainWIREDINIT_TASK_PRIORITY, NULL);
    xTaskCreate(prv485OUTTask, "485O", 600, NULL, mainOUT_TASK_PRIORITY, NULL);
    xTaskCreate(prv485INTask, "485I", 600, NULL, mainIN_TASK_PRIORITY, NULL);
    xTaskCreate(prvRoundRobinTask, "RR", 600, NULL, mainIN_TASK_PRIORITY, NULL);
    
    xTaskCreate(prvXBEEOUTTask, "XBO", 600, NULL, mainOUT_TASK_PRIORITY, NULL);
    xTaskCreate(prvXBEEINTask, "XBI", 600, NULL, mainIN_TASK_PRIORITY, NULL);
    
    xTaskCreate(dsioOUTTask, "INDOUT", 250, NULL, mainINDOUT_TASK_PRIORITY, NULL);
    xTaskCreate(dsIOSTATUS, "STAT", 250, NULL, mainSTAT_TASK_PRIORITY, NULL);
    //setup modules (no modules for the coordinator)
    
    //setup event group
    
    xEventInit = xEventGroupCreate();
    
    //setup USART
    
    USART0_init();
    USART2_init();
    
    PORTD.DIRSET = PIN6_bm;
    
    //USART 485 control pin
    
    PORTD.DIRSET = PIN7_bm;
    PORTD.OUTCLR = PIN7_bm;
    
    //setup buffers and streams
    
    xRS485_in_Stream = xStreamBufferCreate(20, 1); //size of 20 bytes, 1 byte trigger
    xRS485_out_Stream = xStreamBufferCreate(MAX_MESSAGE_SIZE, 1);
    xRS485_out_Buffer = xMessageBufferCreate(MAX_MESSAGE_SIZE * 2); //size of 400 bytes
    xRoundRobin_Buffer = xMessageBufferCreate(20); //size of 20 bytes
    
    xXBEE_in_Stream = xStreamBufferCreate(20, 1); //size of 20 bytes, 1 byte trigger
    xXBEE_out_Stream = xStreamBufferCreate(MAX_MESSAGE_SIZE, 1);
    xXBEE_out_Buffer = xMessageBufferCreate(MAX_MESSAGE_SIZE * 2);
    
    //setup mutex(es)
    
    xUSART0_MUTEX = xSemaphoreCreateMutex();
    xRoundRobin_MUTEX = xSemaphoreCreateMutex();
    x485_MUTEX = xSemaphoreCreateMutex();
    xXBEE_MUTEX = xSemaphoreCreateMutex();
    
    //setup semaphore
    
    xRS485TX_SEM = xSemaphoreCreateBinary();
    xXBEETX_SEM = xSemaphoreCreateBinary();
    
    
    //setup the semaphore
    xBattCheckTrig = xSemaphoreCreateBinary();
    xSemaphoreGive(xBattCheckTrig);
    
    //prepare ADC
    ADC_init();
    
    //setup queues
    xDeviceIN_Queue = xQueueCreate(3, 2 * sizeof(uint8_t)); // intertask messages to the device specific task
    xSTAT_Queue = xQueueCreate(1, 1 * sizeof(uint16_t)); // messages from RESRDY
    xIND_Queue = xQueueCreate(4, 2 * sizeof(uint8_t)); // up to 4 Indicator Commands held
    
    //setup timers
    xINDTimer = xTimerCreate("INDT", 250, pdTRUE, 0, vINDTimerFunc);
    xBATTTimer = xTimerCreate("STAT", 500, pdFALSE, 0, vBattCheckTimerFunc);
    //done with pre-scheduler initialization, start scheduler
        
    //start the indicator timer
    xTimerStart(xINDTimer, 0);
    
    vTaskStartScheduler();
    return (EXIT_SUCCESS);
}

//wired tasks

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
    uint8_t outbuffer[2] = {'S', 'F'};
    
    //wait half a second to ensure all wired devices are active
    
    vTaskDelay(500);
    xQueueSendToBack(xIND_Queue, outbuffer, 10);
    
    //enable transmit complete interrupt
    USART0.CTRLA |= USART_TXCIE_bm;
    USART1.CTRLA |= USART_TXCIE_bm;
    USART2.CTRLA |= USART_TXCIE_bm;
    
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
        //transmission is now complete, listen for the response for up to 10 cycles
        xStreamBufferReceive(xRS485_in_Stream, byte_buffer, 1, 10);
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
    outbuffer[1] = 'S';
    xQueueSendToBack(xIND_Queue, outbuffer, 10); //set status light to solid
    vTaskDelay(100); //wait for 100ms
    xEventGroupSetBits(xEventInit, 0x1);
    vTaskSuspend(NULL);
}

void prv485OUTTask( void * parameters )
{
    uint8_t output_buffer[MAX_MESSAGE_SIZE]; //output buffer
    uint8_t output_leader[2] = {0x7e, 0}; //output leader
    uint8_t length = 0;  //message length
    //this is fairly simple, just output the message buffer when the bus is available.
    //message length should be taken directly from the stream receive.
    //wait for initialization
    xEventGroupWaitBits(xEventInit, 0x1, pdFALSE, pdFALSE, portMAX_DELAY);
    for(;;)
    {
        for(uint8_t i = 0; i < MAX_MESSAGE_SIZE; i++)
            output_buffer[i] = 0;
        //wait until a message arrives in the buffer
        length = xMessageBufferReceive(xRS485_out_Buffer, output_buffer, MAX_MESSAGE_SIZE, portMAX_DELAY);
        //acquire MUTEX after pulling message into internal buffer
        xSemaphoreTake(xUSART0_MUTEX, portMAX_DELAY);
        if(xSemaphoreTake(xRoundRobin_MUTEX, 500) == pdTRUE)
        {
            output_leader[1] = length;
            xStreamBufferSend(xRS485_out_Stream, output_leader, 2, 0);
            //pass message to the output buffer
            xStreamBufferSend(xRS485_out_Stream, output_buffer, length, 0);
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
        else //couldn't acquire round_robin mutex, abort
        {
            xSemaphoreGive(xUSART0_MUTEX);
        }
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
        if(xStreamBufferReceive(xRS485_in_Stream, byte_buffer, 1, 200) == 0)
            //timeout that releases the Mutex in case of a message failure
        {
            xSemaphoreGive(xUSART0_MUTEX);
            byte_buffer[0] = 0x0;
        }
        //check for start delimiter
        if(byte_buffer[0] == 0x7e)
        {
            //take mutex
            xSemaphoreTake(xUSART0_MUTEX, portMAX_DELAY);
            //next byte should be length
            xStreamBufferReceive(xRS485_in_Stream, byte_buffer, 1, 50); //at worst, this will collect garbage, but it shouldn't lock up
            length = byte_buffer[0];
        }
        else
            length = 0; //just ignore this message, something went wrong
        
        //now we hold the MUTEX and know the message length(if there is a message)
        for(uint8_t i = 0; i < length; i++)
        {
            //assemble the message byte by byte until the length is reached
            if(xStreamBufferReceive(xRS485_in_Stream, byte_buffer, 1, 10) != 0)
                message_buffer[i] = byte_buffer[0];
            //if nothing is received, cancel message receipt. Something went wrong
            else
                length = 0;
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
                    xMessageBufferSend(xRoundRobin_Buffer, byte_buffer, 1, 5); //do not block, if the buffer is full than just discard the message
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
                            i = 3;
                        }
                    }
                    
                    if(wirelesscheck != 0) //if there is a wireless address, route to the wireless task
                    {
                        //this will need to grab the MUTEX for the wireless buffer and send the message
                        //block for no more than 50 cycles
                        if(xSemaphoreTake(xXBEE_MUTEX, 50) == pdTRUE)
                        {
                            xMessageBufferSend(xXBEE_out_Buffer, message_buffer, length, 0); //do not block, if the buffer is full then just discard the message
                            xSemaphoreGive(xXBEE_MUTEX);
                        }
                    }
                    else if(message_buffer[2] == 0) //send to menu controller (if attached)
                    {
                    }
                    xSemaphoreGive(xUSART0_MUTEX);
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
            {
                //then, try secure the output
                if(xSemaphoreTake(xRoundRobin_MUTEX, 500) == pdTRUE)
                {
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
                    acknowledge[0] = 0; //overwrite to prevent false allowance
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
                else //if unable to secure the output, just release the input
                {
                    xSemaphoreGive(xUSART0_MUTEX);
                }
            }
        }
    }
}

//wireless tasks

void prvXBEEOUTTask( void * parameters )
{
    //take messages from the 485 or menu task, rearrange the header, and send over the wireless network
    //the first byte of each message is garbage, it is related to the wired network header and can be safely replaced with the 0x7e starting byte
    //the task will make use of an input buffer and an output header buffer, 
    //it will pull out the parts of the input message that it needs and insert them into the output header, then truncate the input message.
    //this is to save on RAM at a slight processing cost from truncating the input string
    uint8_t buffer[MAX_MESSAGE_SIZE];
    uint32_t checksumcalc = 0;
    uint8_t header_buffer[20];
    uint8_t size = 0;
    uint8_t length = 0; //message length from header
    //wait for initialization
    xEventGroupWaitBits(xEventInit, 0x1, pdFALSE, pdFALSE, portMAX_DELAY);
    //looping section, send one message at a time similar to the modular task, but pulling from the input string instead of the device table
    for(;;)
    {
        /* Message Structure Wired and Wireless
         *  Wired (from 485 in or Menu in):
         *  Byte 0 = Message type (we don't care about this) [size - 1]
         *  Byte 1 = Wired Address (we need to move this to header) [size doesn't change]
         *  Byte 2 = Channel (we need to move this to header) [size doesn't change]
         *  Byte 3 = Device Type (we need to move this to header) [size doesn't change]
         *  Byte 4 = first byte of wireless address (we need to move this to header) [size doesn't change]
         *  -
         *  Byte 11 = last byte of wireless address (this all needs to move to header) [size doesn't change]
         *  Byte 12+ = message (needs to move to byte 0) [size doesn't change]
         * 
         *  Wireless (from this task to the Xbee):
         *  Byte 0 = start delimiter (not included in count) [size doesn't change]
         *  Byte 1 = MSB of length (probably always 0) [size doesn't change]
         *  Byte 2 = LSB of length (we will change this to match the size) [size doesn't change]
         *  Byte 3 = Message type (this will probably always be 0x10) [size + 1]
         *  Byte 4 = frame ID (always 0) [size + 1]
         *  Byte 5 = Start of wireless address (taken from input) [size doesn't change]
         *  -
         *  Byte 12 = End of wireless address (taken from input) [size doesn't change]
         *  Byte 13 = start of 16 bit address (always unknown) [size + 1]
         *  Byte 14 = end of 16 bit address (always unknown) [size + 1]
         *  Byte 15 = Broadcast radius (always 0x0) [size + 1]
         *  Byte 16 = Broadcast option (always 0x0) [size + 1]
         *  Byte 17 = Wired address (taken from input) [size doesn't change]
         *  Byte 18 = Channel (taken from input) [size doesn't change]
         *  Byte 19 = Device Type (taken from input) [size doesn't change]
         * 
         * overall size change is + 4 for header differences
         */
        checksumcalc = 0;
        //loop through messages, send one at a time to the XBEE with the header attached
        size = xMessageBufferReceive(xXBEE_out_Buffer, buffer, MAX_MESSAGE_SIZE, 500);
        if(size != 0) //generate header based on the information from the message, then truncate the message and load both into the stream
        {
            //message starts at byte 12 of input
            length = size + 5; //add header to length
            header_buffer[0] = 0x7e; //start delimiter
            header_buffer[1] = 0x00; //length MSB
            header_buffer[2] = length; //length LSB
            header_buffer[3] = 0x10; //Transmit request
            header_buffer[4] = 0x00; //no frame ID
            header_buffer[5] = buffer[4]; //destination address
            header_buffer[6] = buffer[5];
            header_buffer[7] = buffer[6];
            header_buffer[8] = buffer[7];
            header_buffer[9] = buffer[8];
            header_buffer[10] = buffer[9];
            header_buffer[11] = buffer[10];
            header_buffer[12] = buffer[11];
            header_buffer[13] = 0xff; //start of 16 bit address
            header_buffer[14] = 0xfe; //end of 16 bit address
            header_buffer[15] = 0x00; //broadcast radius
            header_buffer[16] = 0x00; //no transmission options
            header_buffer[17] = buffer[1]; //DeviceID
            header_buffer[18] = buffer[2]; //Channel
            header_buffer[19] = buffer[3]; //Device Type
            //load output header
            xStreamBufferSend(xXBEE_out_Stream, header_buffer, 20, 0);
            //truncate the input buffer
            for(uint8_t i = 12; i < size; i++)
            {
                buffer[i - 12] = buffer[i];
            }
            size = size - 12; //remove the length of the wired header
            //calculate checksum and load it into the buffer
            for(uint8_t i = 3; i < 20; i++)
            {
                checksumcalc += header_buffer[i];
            }
            for(uint8_t i = 0; i < size; i++)
            {
                checksumcalc += buffer[i];
            }
            size++; //add a spot for the checksum
            buffer[size - 1] = 0xff - (checksumcalc & 0xff);
            //load output message (includes checksum on end, replacing the index)
            xStreamBufferSend(xXBEE_out_Stream, buffer, size, 0);
        }
        if(size != 0)
        {
            //enable DRE interrupt
            USART2.CTRLA |= USART_DREIE_bm;
            //wait for TXcomplete notification
            xSemaphoreTake(xXBEETX_SEM, portMAX_DELAY);
        }
    }
}

void prvXBEEINTask( void * parameters )
{
    //take messages from the XBEE, rearrange the header, and send to the 485 or menu task.
    //menu task is targeted by channel zero, but if the device is a menu then it may also be transmitted on the wired network.
    //it should be assumed that any message targeted at this device is intended for the wired network, so we should always transmit.
    /* Wireless in handling
     * wait for initialization
     * Listen for start delimiter -> grab length and start counting
     *      depending on message type:
     *      if channel 0 and not a menu, then just route it to the menu
     *      if channel 0 and a menu, then route it to the menu and the wired network
     *      all other cases are routed to the wired network
     */
    uint8_t buffer[MAX_MESSAGE_SIZE];
    uint8_t outbuffer[MAX_MESSAGE_SIZE];
    uint8_t byte_buffer[1];
    uint8_t length = 0;
    volatile uint8_t size = 0;
    uint8_t pos = 0;
    uint8_t check = 0; //check for message failure
    xEventGroupWaitBits(xEventInit, 0x1, pdFALSE, pdFALSE, portMAX_DELAY); // wait for init
    
    for(;;)
    {
        //wait for start delimiter, can wait forever
        //(may implement a 'no activity' warning here later)
        xStreamBufferReceive(xXBEE_in_Stream, byte_buffer, 1, portMAX_DELAY);
        if(byte_buffer[0] == 0x7E)
        {
            pos = 0;
            //next 2 bytes are length, grab length for message construction loop
            //if the length is greater than 255, we are gonna have a bad time to begin with
            //just discard the first byte
            check = xStreamBufferReceive(xXBEE_in_Stream, byte_buffer, 1, 10);
            if(check > 0)
            {
                xStreamBufferReceive(xXBEE_in_Stream, byte_buffer, 1, 10);
                length = byte_buffer[0]; // load loop iterator
                size = length; //save length for use later
                //loop and assemble message until length = 0;`1
                uint32_t checksumcalc = 0;
                for(uint8_t i = 0; i < MAX_MESSAGE_SIZE; i++)
                    buffer[i] = 0;
                while(length > 0)
                {
                    check = xStreamBufferReceive(xXBEE_in_Stream, byte_buffer, 1, 10);
                    if(check > 0)
                    {
                        buffer[pos] = byte_buffer[0];
                        checksumcalc += byte_buffer[0];
                        pos++;
                        length--;
                    }
                    else //message receipt failure, discard message and stop waiting
                    {
                        length = 0;
                        buffer[0] = 0;
                    }
                }
                xStreamBufferReceive(xXBEE_in_Stream, byte_buffer, 1, 10); //this should be the checksum
                checksumcalc += byte_buffer[0]; // last two digits should be 0xff
                if((checksumcalc & 0xff) != 0xff) //if the checksum fails
                {
                    buffer[0] = 0;
                    size = 0;
                }
            }
            else
                buffer[0] = 0;
        }
        else //if not 0x7E, then something broke and we should not run the rest of the process
            buffer[0] = 0; //set buffer out of bounds to ensure nothing happens with a previous message.
        
        //message should now be full assembled, check message type (should be index 0)
        switch(buffer[0])
        {
            case 0x90: //receive packet
                //re-arrange header to match wired format (type 'I')
                /* Message Structure Wired and Wireless
                 *  Wireless (from XBEE to this task):
                 *  Byte 0 = start delimiter (not included in count) [size doesn't change]
                 *  Byte 1 = MSB of length (probably always 0) [size doesn't change]
                 *  Byte 2 = LSB of length (we will change this to match the size) [size doesn't change]
                 *  Byte 3 = Message type (discarded for wired) [size - 1]
                 *  Byte 5 = Start of wireless address (move to output) [size doesn't change]
                 *  -
                 *  Byte 12 = End of wireless address (move to output) [size doesn't change]
                 *  Byte 13 = start of 16 bit address (always unknown) [size - 1]
                 *  Byte 14 = end of 16 bit address (always unknown) [size - 1]
                 *  Byte 17 = Wired address (move to output) [size doesn't change]
                 *  Byte 18 = Channel (move to output) [size doesn't change]
                 *  Byte 19 = Device Type (move to output) [size doesn't change]
                 *  Byte 20+ = Message
                 * 
                 *  Wired (to 485 or menu):
                 *  Byte 0 = Message type (should be 'I') [size + 1]
                 *  Byte 1 = Wired Address (we need to move this from header) [size doesn't change]
                 *  Byte 2 = Channel (we need to move this from header) [size doesn't change]
                 *  Byte 3 = Device Type (we need to move this from header) [size doesn't change]
                 *  Byte 4 = first byte of wireless address (we need to move this from header) [size doesn't change]
                 *  -
                 *  Byte 11 = last byte of wireless address (this all needs to move from header) [size doesn't change]
                 *  Byte 12+ = message (taken from input) [size doesn't change]
                 * 
                 * overall size change is - 4 for header differences
                 */
                //check against checksum
                {
                    //change size
                    size = size - 2;
                    //reassemble the message in the output buffer
                    for(uint8_t i = 0; i < MAX_MESSAGE_SIZE; i++)
                    outbuffer[i] = 0;
                    outbuffer[0] = 'I'; //always inbound
                    outbuffer[1] = buffer[12]; //wired address
                    outbuffer[2] = buffer[13]; //channel number
                    outbuffer[3] = buffer[14]; //device type
                    outbuffer[4] = buffer[1]; //start of wireless address
                    outbuffer[5] = buffer[2];
                    outbuffer[6] = buffer[3];
                    outbuffer[7] = buffer[4];
                    outbuffer[8] = buffer[5];
                    outbuffer[9] = buffer[6];
                    outbuffer[10] = buffer[7];
                    outbuffer[11] = buffer[8]; //end of wireless address]
                    for(uint8_t i = 12; i < size + 2; i++) //move message to the correct spot
                    {
                        outbuffer[i] = buffer[i + 3];
                    }
                    //now the outbuffer should be loaded with the correct message, move to routing
                    if(outbuffer[2] == 0) //channel zero always goes to menu
                    {
                        if(outbuffer[3] == 'M') //if the device type is menu, then also transmit on wired network
                        {
                            if(xSemaphoreTake(x485_MUTEX, 50) == pdTRUE)
                            {
                                xMessageBufferSend(xRS485_out_Buffer, outbuffer, MAX_MESSAGE_SIZE, 0);
                                xSemaphoreGive(x485_MUTEX);
                            }
                        }
                    }
                    else //all other cases transmit over the wired network
                    {
                        if(xSemaphoreTake(x485_MUTEX, 50) == pdTRUE)
                        {
                            xMessageBufferSend(xRS485_out_Buffer, outbuffer, MAX_MESSAGE_SIZE, 0);
                            xSemaphoreGive(x485_MUTEX);
                        }
                    }
                }
                break;
        }
        
    }
}

void dsIOSTATUS (void * parameters)
{
    for(;;)
    {
        volatile uint8_t output = 0;
        uint8_t outbuffer[2] = {'S', 'F'};
        uint16_t received[1];
        //block on manual trigger semaphore
        if(xSemaphoreTake(xBattCheckTrig, 50) == pdTRUE)
        {
            //check the battery voltage
            VoltageCheck();
            //wait for result before moving on
            xQueueReceive(xSTAT_Queue, received, portMAX_DELAY); //check output after starting the sample, but before blocking
            //check against reference value of 2402 (~1.935V over resistor)
            if(received[0] < 2402)
            {
                //low battery state, send the message to the main task
                xQueueSendToBack(xIND_Queue, outbuffer, 10);
            }
            xBATTTimerSet = 0;
            xTimerReset(xBATTTimer, 0);
        }
        else //if not a manual trigger, then check timer and do the periodic if the time is right
        {
            if(xBATTTimerSet == 1)
            {
                //check the battery voltage
                VoltageCheck();
                //wait for result before moving on
                xQueueReceive(xSTAT_Queue, received, portMAX_DELAY); //check output after starting the sample, but before blocking
                //check against reference value of 2402 (~1.935V over resistor)
                if(received[0] < 2402)
                {
                    //low battery state, send the message to the main task
                    xQueueSendToBack(xIND_Queue, outbuffer, 10);
                }
                xBATTTimerSet = 0;
                xTimerReset(xBATTTimer, 0);
            }
        }
    }
}

void dsioOUTTask (void * parameters)
{
    //blink, flash, solid, etc.
    //this controls the three indicators on the console
    //blink should be somewhat slow, flash should be faster (mostly used for blue, initialization, and maybe errors)
    
    //indicator state buffers initialized to zero
    static uint8_t STAT = 0;
    
    //time buffers for flash and latches
    static uint8_t flash = 0; 
    static uint8_t blink = 0; 
    static uint8_t ms250 = 0;
    
    //receiver buffer
    uint8_t received[2];
    
    //running loop
    for(;;)
    {
        //first, check for commands from other tasks (hold for 50ms)
        if(xQueueReceive(xIND_Queue, received, 20) == pdTRUE)
        {
        switch(received[0]) //first check the intended target
        {
            case 0x0: //do nothing/no target
                break;
            case 'S': //Stat indicator
                STAT = received[1];
                break;
                
            case 0xff: //All indicators
                STAT = received[1];
                break;
        }
        }
        //if timer has triggered, increment ms250 and reset flash and blink timers
        if(xINDTimerSet == 1)
        {
            ms250++;
            if(ms250 == 5)
            {
                ms250 = 0;
                blink = 0;
            }
            flash = 0;
            xINDTimerSet = 0;
        }
        //process stat
        switch(STAT)
        {
            case 'B': //blink
                if(blink == 0 && ms250 == 0)
                    dsioStatTGL();
                break;

            case 'F': //flash
                if(flash == 0)
                    dsioStatTGL();
                break;

            case 'D': //double flash
                if(flash == 0)
                {
                    dsioStatOn();
                    vTaskDelay(5);
                    dsioStatTGL();
                    vTaskDelay(5);
                    dsioStatTGL();
                    vTaskDelay(5);
                    dsioStatOff();
                }
                break;

            case 'W': //warning flash (used for lockout warning)
                dsioStatOn();
                vTaskDelay(5);
                dsioStatTGL();
                vTaskDelay(5);
                dsioStatTGL();
                vTaskDelay(5);
                dsioStatTGL();
                vTaskDelay(5);
                dsioStatTGL();
                vTaskDelay(5);
                dsioStatTGL();
                vTaskDelay(5);
                dsioStatTGL();
                vTaskDelay(5);
                dsioStatOff();
                break;

            case 'S': //solid
                dsioStatOn();
                break;

            case 'O': //off
                dsioStatOff();
                break;
        }
        //set blink and flash
        blink = 1;
        flash = 1;
    }
}

//helper functions:

void dsioStatOn(void)
{
    PORTD.OUTSET = PIN6_bm;
}
void dsioStatOff(void)
{
    PORTD.OUTCLR = PIN6_bm;
}
void dsioStatTGL(void)
{
    PORTD.OUTTGL = PIN6_bm;
}

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

void vINDTimerFunc( TimerHandle_t xTimer )
{
    xINDTimerSet = 1;
}

void vBattCheckTimerFunc( TimerHandle_t xTimer )
{
    xBATTTimerSet = 1;
}

void VoltageCheck(void)
{
    ADC0.MUXPOS = ADC_MUXPOS_AIN0_gc;
    ADC0.COMMAND = 0x1;
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

ISR(USART2_RXC_vect)
{
    //move the data receive register into the stream for the input task, this clears the interrupt automatically
    uint8_t buf[1];
    buf[0] = USART2.RXDATAL;
    xMessageBufferSendFromISR(xXBEE_in_Stream, buf, 1, NULL);
}
ISR(USART2_DRE_vect)
{
    /* Data Register empty Interrupt
     * 1. pull from output stream buffer and put in TX register until clear
     * 2. disable interrupt after end of message
     */
    uint8_t buf[1];
    if(xStreamBufferReceiveFromISR(xXBEE_out_Stream, buf, 1, NULL) == 0) //if end of message
    {
        USART2.CTRLA &= ~USART_DREIE_bm; //disable interrupt
    }
    else
        USART2.TXDATAL = buf[0];
}
ISR(USART2_TXC_vect)
{
    /* Transmission complete interrupts
     * 1. set semaphore
     * 2. clear interrupt flag
     */
    USART2.STATUS |= USART_TXCIF_bm; //clear flag by writing a 1 to it
    xSemaphoreGiveFromISR(xXBEETX_SEM, NULL);
}

ISR(ADC0_RESRDY_vect)
{
    uint16_t res[1];
    res[0] = ADC0.RES; //this should also clear the interrupt flag
    xQueueSendToBackFromISR(xSTAT_Queue, res, NULL);
    ADC0.MUXPOS = ADC_MUXPOS_GND_gc;
}