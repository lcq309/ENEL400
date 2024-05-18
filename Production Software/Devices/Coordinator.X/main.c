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

#define F_CPU 24000000UL // cpu speed for delay utilities

#define MAX_MESSAGE_SIZE 200 //maximum message size allowable
#define LIST_LENGTH 255 //max length of device list

#include <stdio.h>
#include <stdlib.h>
#include "USART.h"
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include <avr/ioavr128da28.h>
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
#define main485OUT_TASK_PRIORITY (tskIDLE_PRIORITY + 3)
#define main485IN_TASK_PRIORITY (tskIDLE_PRIORITY + 4)
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
    PORTD.DIRCLR = PIN7_bm;
    
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
    
    //wait half a second to ensure all wired devices are active
    
    _delay_ms(500);
    
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
    //take the mutex
    xSemaphoreTake(xUSART0_MUTEX, portMAX_DELAY);
    
    //loop and send pings, wait up to 2 cycles for a response, and move to the next one.
    
    for(uint8_t i = 1; i < LIST_LENGTH; i++)
    {
        Ping[3] = i; //configure ping
        xStreamBufferSend(xRS485_out_Stream, Ping, 4, portMAX_DELAY); //load output buffer with ping
        RS485TR('T'); //set transmit mode
        //start transmission by setting TXCIE, and DREIE
        USART0.CTRLA |= USART_TXCIE_bm;
        USART0.CTRLA |= USART_DREIE_bm;
        //wait for semaphore
        xSemaphoreTake(xRS485TX_SEM, portMAX_DELAY);
        //transmission is now complete, listen for the response for up to 2 cycles
        xStreamBufferReceive(xRS485_in_Stream, byte_buffer, 1, 2);
        if(byte_buffer[0] == 0x7E)
        {
            uint8_t pos = 0;
            //next byte is length, grab length for message construction loop
            xStreamBufferReceive(xCOMM_in_Stream, byte_buffer, 1, portMAX_DELAY);
            length = byte_buffer[0]; // load loop iterator
            //loop and assemble message until length = 0;
            while(length > 0)
            {
                length--;
                xStreamBufferReceive(xCOMM_in_Stream, byte_buffer, 1, portMAX_DELAY);
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
    //The device table and all connected devices should now be initialized.
    //release the init group and suspend the task.
    xEventGroupSetBits(xEventInit, 0x1);
    vTaskSuspend(NULL);
}

void prv485OUTTask( void * parameters )
{
    uint8_t output_buffer[MAX_MESSAGE_SIZE]; //output buffer
    uint8_t wired_leader[2] = {0x7e, 0};
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
        wired_leader[1] = length;
        //add the message leader into the output buffer
        xStreamBufferSend(xRS485_out_Stream, wired_leader, 2, portMAX_DELAY);
        //pass message to the output buffer
        xStreamBufferSend(xRS485_out_Stream, output_buffer, length, portMAX_DELAY);
        //set transmit mode
        RS485TR{'T'};
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
            xStreamBufferReceive(xRS485_in_Stream, byte_buffer, 1, portMAX_DELAY);
            message_buffer[i] = byte_buffer[0];
        }
        //now the full message should be within the message buffer, perform routing
        if(length != 0)
        {
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
                    uint8_t wirelesscheck = 0;
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

void prvWSCTask( void * parameters )
{
    /* Wired Sector Controller
     * maintain a table of controller and light indexes, with a confirmation marker
     * communicate with other controllers on the same channel for coordination
     * communicate with lights on the same channel for coordination
     * lights and controllers will lockout when asked to turn yellow or red
     * controller is responsible for releasing yellow lockout when all lights are yellow
     * stop button is responsible for releasing red lockout at the director's discretion
     * a controller will yield to a controller trying to send a higher priority
     * a light will 'warn' a controller trying to send a lower priority before the lockout has released
     */
    struct DeviceTracker ControllerTable[20]; //maximum of 20 connected controlled devices (probably not a hard limit)
    uint8_t numControllers = 0;
    uint8_t tablePos = 0;
    struct DeviceTracker LightTable[20]; //20 connected lights
    uint8_t numLights = 0;
    struct DeviceTracker SpecialTable[10]; //10 connected special devices (stop button etc)
    uint8_t numSpecials = 0;
    struct DeviceTracker MenuTable[5]; //5 connected menu devices
    uint8_t numMenus = 0;
    uint8_t lockout = 'C'; //used to track lockout status ('Y'ellow, 'R'ed, 'C'lear)
    uint8_t buffer[MAX_MESSAGE_SIZE]; //messaging buffer
    uint8_t length = 0; //message length
    uint8_t updateIND = 0; //set when an indicator update should occur
    uint8_t colour_req = 'O'; //requested colour
    uint8_t colour_cur = 'O'; //current confirmed colour
    uint8_t Requester = 0; //is this device currently requesting a colour change
    
    /* High level overview
     * 1. check for any commands from pushbutton or other internal source.
     * 2. check for any waiting messages.
     * 3. check timer for resending messages if applicable.
     * 4. resend messages if applicable
     * 5. set all indicator colours according to colour_req and colour_cur.
     * 
     * since this is the lowest priority task, it shouldn't need to block for anything on the input side.
     */
    xEventGroupWaitBits(xEventInit, 0x1, pdFALSE, pdFALSE, portMAX_DELAY); //wait for init
    for(;;)
    {
        //internal source commands processing
        if(xQueueReceive(xDeviceIN_Queue, buffer, 0) == pdTRUE)
        {
            //check message source
            switch(buffer[0])
            {
                case 'P': //pushbutton
                    //check if the colour requested is of a higher priority than the current lockout
                    //either allow it through, or flash the current lockout colour
                    switch(lockout)
                    {
                        case 'C': //clear, allow colour change request
                            colour_req = buffer[1];
                            Requester = 1; //we are initiating this change
                            updateIND = 1; //update the indicators
                            break;
                            
                        case 'G': //green lockout, allow yellow through but not blue
                            switch(buffer[1])
                            {
                                case'Y': //yellow light
                                    colour_req = buffer[1];
                                    Requester = 1; //we are initiating this change
                                    updateIND = 1; //update the indicators
                                    break;
                                case'B': //blue light
                                    //flash green for a short time
                                    buffer[0] = 0xff;
                                    buffer[1] = 'O'; //turn all off first
                                    xQueueSendToFront(xIND_Queue, buffer, portMAX_DELAY);
                                    buffer[0] = 'G';
                                    buffer[1] = 'F'; //green flash
                                    xQueueSendToFront(xIND_Queue, buffer, portMAX_DELAY);
                                    vTaskDelay(200);
                                    updateIND = 1;
                                    break;
                            }
                        case 'Y': //yellow lockout, flash yellow for a short time
                            buffer[0] = 0xff;
                            buffer[1] = 'O'; //turn all off first
                            xQueueSendToFront(xIND_Queue, buffer, portMAX_DELAY);
                            buffer[0] = 'Y';
                            buffer[1] = 'F'; //yellow flash
                            xQueueSendToFront(xIND_Queue, buffer, portMAX_DELAY);
                            vTaskDelay(200);
                            updateIND = 1;
                            //running code will fix indicators after this delay has passed.
                            break;
                            
                        case 'R': //red lockout, flash all for a short time
                            buffer[0] = 0xff;
                            buffer[1] = 'O'; //turn all off first
                            xQueueSendToFront(xIND_Queue, buffer, portMAX_DELAY);
                            buffer[0] = 0xff;
                            buffer[1] = 'F'; //flash all
                            xQueueSendToFront(xIND_Queue, buffer, portMAX_DELAY);
                            vTaskDelay(200);
                            updateIND = 1;
                            break;
                    }
                    break;
                //space for other intertask commands here
            }
            
        }
        //check for messages from COMMS, wait up to 200ms
        length = xMessageBufferReceive(xDevice_Buffer, buffer, MAX_MESSAGE_SIZE, 200);
        if(length != 0) //if there is a message in the buffer
        {
            uint8_t router = 0; //byte used for routing from different sources
            //check device type in table and route to correct handling, this section is all just device checks
            switch(GLOBAL_DEVICE_TABLE[buffer[0]].Type)
            {
                case '1': //wired sector controller
                    router = 'C'; //C for controller device
                    break;
                    
                case '2': //wireless sector controller
                    router = 'C';
                    break;
                    
                case '3': //wired light
                    router = 'L';
                    break;
                    
                case '4': //wireless light
                    router = 'L';
                    break;
                    
                case 'S': //stop button card
                    router = 'S';
                    break;
                    
                case 'M': //menu controller
                    router = 'M';
                    break;
                    
                default: //not programmed device type
                    //could put an error here in the future
                    break;
            }
            //confirm if device is present on table
            uint8_t match = 0;
            switch(router)
            {
                case 'C': //controlling device, check if it is on the internal table, add if not
                {
                    for(uint8_t i = 0; i < numControllers; i++)
                    {
                        if(ControllerTable[i].index == buffer[0])
                        {
                            match = 1;
                            tablePos = i;
                            i = numControllers;
                        }
                    }
                    if(match != 1) //if no match found, add to table
                    {
                        ControllerTable[numControllers].index = buffer[0];
                        tablePos = numControllers;
                        numControllers++;
                    }
                    //now the device is on the table, evaluate its message
                    switch(buffer[1]) //first byte of message
                    {
                        case 'B': //blue colour change request
                            //if we are currently requesting blue, this device is also requesting blue at the same time
                            //this should be responded to with a lowercase
                            //if we are not currently requesting blue, this is a colour change request
                            switch(lockout)
                            {
                                case 'C': //Clear, become a subordinate and respond
                                    Requester = 2;
                                    updateIND = 1;
                                    colour_req = 'B';
                                    lockout = 'B';
                                    buffer[1] = ControllerTable[tablePos].index;
                                    buffer[0] = 'b'; //confirmation
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                    break;
                                    
                                case 'B': //Blue lockout
                                    switch(Requester)
                                    {
                                        case 1: //this is a requester one, update status and respond with confirmation
                                            ControllerTable[tablePos].status = buffer[1];
                                            buffer[0] = 'b'; //confirmation
                                            buffer[1] = ControllerTable[tablePos].index;
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                            break;
                                        case 2: //this is a subordinate requester, just respond with confirmation
                                            buffer[0] = 'b'; //confirmation
                                            buffer[1] = ControllerTable[tablePos].index;
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                            break;
                                    }
                                    break;
                                    
                                default: //if there is a lockout, respond with the lockout colour
                                    buffer[0] = lockout;
                                    buffer[1] = ControllerTable[tablePos].index; //respond with controller lockout colour
                                    //this should set the controller as requester 2 with a lockout
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                    break;
                            }
                            break;
                        case 'b': //blue confirmation
                            //if we are requester 1 for a blue colour change, mark status as confirmed.
                            //if lockout level is above blue, send a colour change request to the lockout level.
                            switch(lockout)
                            {
                                case 'B': //blue lockout
                                    if(Requester == 1)
                                        ControllerTable[tablePos].status = 'B';
                                    break;
                                default: //other lockout level, just ignore
                                    break;
                            }
                            break;
                        case 'G': //Green colour change request
                            //if we are requesting blue, green will override it
                            switch(lockout)
                            {
                                case 'C': //no lockout, this is a green request from another controller
                                    //set lockout and colour_req to green, update controller status, and reply
                                    ControllerTable[tablePos].status = buffer[1];
                                    updateIND = 1;
                                    lockout = 'G';
                                    colour_req = 'G';
                                    Requester = 2; //start helping with colour change
                                    buffer[0] = 'g';
                                    buffer[1] = ControllerTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                    break;
                                
                                case 'B': //blue lockout will be overridden
                                    ControllerTable[tablePos].status = buffer[1];
                                    updateIND = 1;
                                    lockout = 'G';
                                    colour_req = 'G';
                                    Requester = 2;
                                    buffer[0] = 'g';
                                    buffer[1] = ControllerTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                    break;
                                    
                                case 'G': //green lockout
                                    switch(Requester)
                                    {
                                        case 1: //this is a requester one, update status and respond with confirmation
                                            ControllerTable[tablePos].status = buffer[1];
                                            buffer[0] = 'g'; //confirmation
                                            buffer[1] = ControllerTable[tablePos].index;
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                            break;
                                        case 2: //this is a subordinate requester, just respond with confirmation
                                            buffer[0] = 'g'; //confirmation
                                            buffer[1] = ControllerTable[tablePos].index;
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                            break;
                                    }
                                    break;
                                default: //other lockout level, reply with lockout level
                                    buffer[0] = lockout; 
                                    buffer[1] = ControllerTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                    break;
                            }
                            break;
                        case 'g': //green colour change confirmation
                            switch(lockout)
                            {
                                case 'G': //green lockout, mark as confirmed if Requester 1
                                    if(Requester == 1)
                                        ControllerTable[tablePos].status = 'G';
                                    break;
                                default: //other lockout level, just ignore
                                    break;
                            }
                            break;
                            
                        case 'Y': //yellow colour change request
                            switch(lockout)
                            {
                                case 'C': //no lockout, this is a yellow request from another controller
                                    //set lockout and colour_req to green, update controller status, and reply
                                    ControllerTable[tablePos].status = buffer[1];
                                    updateIND = 1;
                                    lockout = 'Y';
                                    colour_req = 'Y';
                                    Requester = 2; //start helping with colour change
                                    buffer[0] = 'y';
                                    buffer[1] = ControllerTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                    break;
                                
                                case 'B': //blue lockout will be overridden
                                    ControllerTable[tablePos].status = buffer[1];
                                    updateIND = 1;
                                    lockout = 'Y';
                                    colour_req = 'Y';
                                    Requester = 2;
                                    buffer[0] = 'y';
                                    buffer[1] = ControllerTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                    break;
                                    
                                case 'G': //green lockout will be overridden
                                    ControllerTable[tablePos].status = buffer[1];
                                    updateIND = 1;
                                    lockout = 'Y';
                                    colour_req = 'Y';
                                    Requester = 2;
                                    buffer[0] = 'y';
                                    buffer[1] = ControllerTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                    break;
                                    
                                case 'Y': //yellow lockout
                                    switch(Requester)
                                    {
                                        case 1: //this is a requester one, update status and respond with confirmation
                                            ControllerTable[tablePos].status = buffer[1];
                                            buffer[0] = 'y'; //confirmation
                                            buffer[1] = ControllerTable[tablePos].index;
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                            break;
                                        case 2: //this is a subordinate requester, just respond with confirmation
                                            buffer[0] = 'y'; //confirmation
                                            buffer[1] = ControllerTable[tablePos].index;
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                            break;
                                    }
                                    break;
                                default: //other lockout level, reply with lockout level
                                    buffer[0] = lockout; 
                                    buffer[1] = ControllerTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                    break;
                            }
                            break;
                            
                        case 'y': //confirm yellow 
                            switch(lockout)
                            {
                                case 'Y': //green lockout, mark as confirmed if Requester 1
                                    if(Requester == 1)
                                        ControllerTable[tablePos].status = 'Y';
                                    break;
                                default: //other lockout level, just ignore
                                    break;
                            }
                            break;
                            
                        case 'R': //red requested by default become a subordinate and confirm
                            ControllerTable[tablePos].status = buffer[1];
                            lockout = 'R';
                            colour_req = 'R';
                            updateIND = 1;
                            Requester = 2;
                            buffer[0] = 'r';
                            buffer[1] = ControllerTable[tablePos].index;
                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                            break;
                            
                        case 'r': //red confirmation, shouldn't end up here normally, just ignore for now
                            break;
                            
                        //lockout clear requests go here
                        case 'C':
                            switch(buffer[2])
                            {
                                case 'B': //clear blue lockout, clear and confirm by sending 'c' 'b' in response
                                    switch(lockout)
                                    {
                                        case 'C': //lockout already cleared, confirm
                                            buffer[0] = 'c';
                                            buffer[1] = ControllerTable[tablePos].index;
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                            break;
                                        case 'B': //clear the blue lockout and confirm clearance.
                                            if(Requester == 1) //if we are responsible for releasing lights, don't change lockout level yet
                                                lockout = 'B';
                                            else
                                            {
                                                lockout = 'C';
                                                colour_cur = 'B';
                                                updateIND = 1;
                                            }
                                            buffer[0] = 'c';
                                            buffer[1] = ControllerTable[tablePos].index;
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                            break;
                                            
                                        case 'b': //we are working on clearing lights, just confirm clearance.
                                            buffer[0] = 'c';
                                            buffer[1] = ControllerTable[tablePos].index;
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                            break;
                                            
                                        default: //just ignore anything else for now
                                            break;
                                    }
                                    break;
                                    
                                case 'Y': //clear yellow lockout, clear and confirm by sending 'c' 'y' in response
                                    switch(lockout)
                                    {
                                            case 'C': //lockout already cleared, confirm
                                            buffer[0] = 'c';
                                            buffer[1] = ControllerTable[tablePos].index;
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                            break;
                                            
                                        case 'Y': //clear the yellow lockout and confirm clearance.
                                            if(Requester == 1) //if we are responsible for releasing lights, don't change lockout level yet
                                                lockout = 'Y';
                                            else    //if we are not responsible for releasing lights, assume all lights are the correct colour
                                            {
                                                lockout = 'C';
                                                colour_cur = 'Y';
                                                updateIND = 1;
                                            }
                                            buffer[0] = 'c';
                                            buffer[1] = ControllerTable[tablePos].index;
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                            break;
                                            
                                        case 'y': //we are working on clearing lights, just confirm clearance.
                                            buffer[0] = 'c';
                                            buffer[1] = ControllerTable[tablePos].index;
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                            break;
                                            
                                        default: //just ignore anything else for now
                                            break;
                                    }
                                    break;
                                    
                                case 'G': //clear green lockout, clear and confirm by sending 'c' 'g' in response
                                    switch(lockout)
                                    {
                                        case 'C': //lockout already cleared, confirm
                                            buffer[0] = 'c';
                                            buffer[1] = ControllerTable[tablePos].index;
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                            break;
                                            
                                        case 'G': //clear the yellow lockout and confirm clearance.
                                            if(Requester == 1) //if we are responsible for releasing lights, don't change lockout level yet
                                                lockout = 'G';
                                            else
                                            {
                                                lockout = 'C';
                                                colour_cur = 'G';
                                                updateIND = 1;
                                            }
                                            buffer[0] = 'c';
                                            buffer[1] = ControllerTable[tablePos].index;
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                            break;
                                            
                                        case 'g': //we are working on clearing lights, just confirm clearance.
                                            buffer[0] = 'c';
                                            buffer[1] = ControllerTable[tablePos].index;
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                            break;
                                            
                                        default: //just ignore anything else for now
                                            break;
                                    }
                                    break;
                                    //red clearance not handled by this type of device.
                            }
                            break;
                            
                        case 'c': //clearance confirmation, only relevant to requester 1 devices update status.
                            ControllerTable[tablePos].status = 'C'; //mark device as cleared
                            break;
                        default: //can put an error message here, for incorrect command.
                            break;
                    }
                }
                break;
                
                case 'L': //light device, should only ever be confirming colours or giving an error response (not yet implemented)
                    //just mark starus as confirmed
                    //first check if on the table, add if not
                    for(uint8_t i = 0; i < numLights; i++)
                    {
                        if(LightTable[i].index == buffer[0])
                        {
                            match = 1;
                            tablePos = i;
                            i = numLights;
                        }
                    }
                    if(match != 1) //if no match found, add to table
                    {
                        LightTable[numLights].index = buffer[0];
                        tablePos = numLights;
                        numLights++;
                    }
                    //Light device should now be on the table
                    switch(buffer[1])
                    {
                        case 'E': //Error messages?
                            break;
                            
                        default: //anything else should just be state confirmations
                            LightTable[tablePos].status = (buffer[1] - 32); //subtract 32 to get uppercase letter
                            break;
                    }
                    break;
                    
                case 'S': //special device, stop button and etc. we are always subordinate
                    //check table and add if needed
                    for(uint8_t i = 0; i < numSpecials; i++)
                    {
                        if(SpecialTable[i].index == buffer[0])
                        {
                            match = 1;
                            tablePos = i;
                            i = numSpecials;
                        }
                    }
                    if(match != 1) //if no match found, add to table
                    {
                        SpecialTable[numSpecials].index = buffer[0];
                        tablePos = numSpecials;
                        numSpecials++;
                    }
                    switch(buffer[1])
                    {
                        case 'R': //red request, we are required to turn red
                            lockout = 'R'; //can only be released by Stop button
                            colour_req = 'R';
                            Requester = 2;
                            updateIND = 1;
                            buffer[0] = 'r'; //confirm red
                            buffer[1] = SpecialTable[tablePos].index;
                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                            break;
                            
                        case 'Y': //will send yellow when the stop command has been cleared
                            //overrides any normal colour change logic, will be released by the stop button
                            lockout = 'Y';
                            colour_req = 'Y';
                            Requester = 2;
                            updateIND = 1;
                            buffer[0] = 'y'; //confirm yellow
                            buffer[1] = SpecialTable[tablePos].index;
                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                            break;
                            
                        case 'O': //off command, overrides any normal colour change logic
                            lockout = 'C';
                            colour_req = 'O';
                            Requester = 2;
                            updateIND = 1;
                            buffer[0] = 'o'; //confirm off
                            buffer[1] = SpecialTable[tablePos].index;
                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                            break;
                            
                        case 'C': //Clear command, stop light is special and doesn't need to follow the same rules that a controller would
                            lockout = 'C';
                            buffer[0] = 'c'; //confirm clear
                            buffer[1] = SpecialTable[tablePos].index;
                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                            break;
                    }
                    break;
                    
                case 'M': //menu (to be implemented)
                    
                    break;
            }
            //message processing now complete, check the status of any colour change request
            //if all colours are matching colour_req, then change colour_cur into colour_req
            uint8_t check_variable = 1;
            if(colour_cur != colour_req)
            {
                switch(Requester)
                //how this acts depends on if it is a requester 1 or 2
                {
                    case 1: //Lead Requester
                    //check retransmission timers and retransmit if needed
                        if(GLOBAL_RetransmissionTimerSet == 1)
                        {
                            //check other controllers
                            for(uint8_t i = 0; i < numControllers; i++)
                            {
                                if(ControllerTable[i].status != colour_req)
                                {
                                    //send another colour change request, and set check_variable
                                    buffer[0] = colour_req; //colour_req is the colour we are requesting
                                    buffer[1] = ControllerTable[i].index; //load with retransmission request
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                    check_variable = 0;
                                }
                            }
                            //check lights
                            for(uint8_t i = 0; i < numLights; i++)
                            {
                                if(LightTable[i].status != colour_req)
                                {
                                    //send another colour change request, and set check_variable
                                    buffer[0] = colour_req; //colour_req is the colour we are requesting
                                    buffer[1] = LightTable[i].index; //load with retransmission request
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                    check_variable = 0;
                                }
                            }
                            //if all colours are matching, we can set colour_cur to colour_req
                            if(check_variable == 1)
                            {
                                colour_cur = colour_req;
                            }
                            //reset transmission timer, might also add a separate check to ensure that a transmission has actually occurred.
                            else // if something was transmitted, we need to reset the timer.
                            {
                                GLOBAL_RetransmissionTimerSet = 0;
                                xTimerReset(xRetransmitTimer, portMAX_DELAY);
                            }
                        }
                        break;
                        
                    case 2: //Subordinate Requester
                        if(GLOBAL_RetransmissionTimerSet == 1)
                        {
                            //check lights
                            for(uint8_t i = 0; i < numLights; i++)
                            {
                                if(LightTable[i].status != colour_req)
                                {
                                    //send another colour change request, and set check_variable
                                    buffer[0] = colour_req; //colour_req is the colour we are requesting
                                    buffer[1] = LightTable[i].index; //load with retransmission request
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                    check_variable = 0;
                                }
                            }
                            //if all colours are matching, we can set colour_cur to colour_req
                            if(check_variable == 1)
                            {
                                colour_cur = colour_req;
                            }
                            //reset transmission timer, might also add a separate check to ensure that a transmission has actually occurred.
                            else // if something was transmitted, we need to reset the timer.
                            {
                                GLOBAL_RetransmissionTimerSet = 0;
                                xTimerReset(xRetransmitTimer, portMAX_DELAY);
                            }
                        }
                        break;
                        
                    case 0: //just do nothing if we are not set to request anything
                        break;
                }
            }
            check_variable = 1;
            //if we are requester 1, we should ensure that first the controller lockouts are released
            //as a requester 2, we can return to requester 0 once all lights have confirmed colour
            switch(Requester)
            {
                case 1:
                    if((lockout == colour_cur) && (GLOBAL_RetransmissionTimerSet == 1)) //at this point, all devices have confirmed change and we should start releasing lockouts
                    {
                        for(uint8_t i = 0; i < numControllers; i++)
                            {
                                if(ControllerTable[i].status != 'C') //if not confirmed cleared
                                {
                                    //send another clear request, and set check_variable
                                    buffer[0] = colour_req; //colour_req is the colour we are requesting
                                    buffer[1] = ControllerTable[i].index; //load with retransmission request
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                    check_variable = 0;
                                }
                            }
                        //if all controllers are confirmed, we can move on to releasing lights
                        if(check_variable == 1)
                        {
                            lockout = lockout + 32; //switch to lowercase lockout letter
                        }
                        //reset transmission timer, might also add a separate check to ensure that a transmission has actually occurred.
                        else // if something was transmitted, we need to reset the timer.
                        {
                            GLOBAL_RetransmissionTimerSet = 0;
                            xTimerReset(xRetransmitTimer, portMAX_DELAY);
                        }
                    }
                    else if((lockout == (colour_cur + 32) && (GLOBAL_RetransmissionTimerSet == 1))) //at this point, all controllers have confirmed lockout release
                    {//we can begin releasing the lights
                        for(uint8_t i = 0; i < numLights; i++)
                        {
                            if(LightTable[i].status != 'C') //if not confirmed cleared
                            {
                                //send another clear request, and set check_variable
                                buffer[0] = colour_req; //colour_req is the colour we are requesting
                                buffer[1] = LightTable[i].index; //load with retransmission request
                                xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                check_variable = 0;
                            }
                        }
                        //if all controllers and lights are confirmed, we can release internal lockout and return to requester 0
                        //but there is a special case for blue, where we should return the lights to green after a delay.
                        //this needs some more discussion
                        if(check_variable == 1)
                        {
                            lockout = 'C';
                            Requester = 0;
                        }
                        //reset transmission timer, might also add a separate check to ensure that a transmission has actually occurred.
                        else // if something was transmitted, we need to reset the timer.
                        {
                            GLOBAL_RetransmissionTimerSet = 0;
                            xTimerReset(xRetransmitTimer, portMAX_DELAY);
                        }
                    }
                    break;
                    
                case 2: // we can return to requester 0 if the lights have confirmed colour
                    if(colour_cur == colour_req)
                        Requester = 0;
                    break;
                case 0:
                    break;
            }
            //update indicators if needed
            if(updateIND == 1)
            {
                if(colour_cur != colour_req)
                {
                    //set both to flash
                    buffer[0] = 0xff; //all indicators
                    buffer[1] = 'O'; //off
                    xQueueSendToBack(xIND_Queue, buffer, portMAX_DELAY);
                    buffer[0] = colour_cur;
                    buffer[1] = 'F'; //flash
                    xQueueSendToBack(xIND_Queue, buffer, portMAX_DELAY);
                    buffer[0] = colour_req;
                    buffer[1] = 'F'; //flash
                    xQueueSendToBack(xIND_Queue, buffer, portMAX_DELAY);
                }
                else if(colour_cur == colour_req)
                {
                    //set solid
                    buffer[0] = 0xff; //all indicators
                    buffer[1] = 'O'; //off
                    xQueueSendToBack(xIND_Queue, buffer, portMAX_DELAY);
                    buffer[0] = colour_cur;
                    buffer[1] = 'S'; //solid
                    xQueueSendToBack(xIND_Queue, buffer, portMAX_DELAY);
                }
                //error case should blink lights slowly.
            }
            //loop and restart
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
            PORTD.DIRSET = PIN72_bm;
            break;
        case 'R': //receive
            PORTD.DIRCLR = PIN7_bm;
            break;
        default: //incorrect command
            break;
    }
}