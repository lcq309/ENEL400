/* 
 * RS 485 Lap count display
 * Author:  Michael King
 * 
 * Created on July 5, 2024
 * 
 * This is the lap count display, accepts commands from controllers
 * 
 */

#include <stdio.h>
#include <stdlib.h>
#include <DSIO.h>
#include <RS485TASKS.h>
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
};

//define global variables
uint8_t GLOBAL_DeviceID = 0;
uint8_t GLOBAL_Channel = 0;
uint8_t GLOBAL_DeviceType = 'l'; //Lap count controller, 'l' is the display.

#define mainWIREDINIT_TASK_PRIORITY (tskIDLE_PRIORITY + 1)
#define mainCOMMOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 4)
#define mainCOMMIN_TASK_PRIORITY (tskIDLE_PRIORITY + 3)
#define mainPBIN_TASK_PRIORITY (tskIDLE_PRIORITY + 4)
#define mainINDOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainWLD_TASK_PRIORITY (tskIDLE_PRIORITY + 1)

#define MaxNets 40

//task pointers

void prvWiredInitTask( void * parameters );
void prvWLDTask( void * parameters );

//retransmission timer

TimerHandle_t xRetransmitTimer;

//timer callback functions

void vRetransmitTimerFunc( TimerHandle_t xTimer );

//timer global

uint8_t GLOBAL_RetransmissionTimerSet = 1; //without setting this, it will never transmit

int main(int argc, char** argv) {
    
    //setup tasks
    xTaskCreate(prvWiredInitTask, "INIT", 300, NULL, mainWIREDINIT_TASK_PRIORITY, NULL);
    xTaskCreate(prvWLDTask, "WLD", 700, NULL, mainWLD_TASK_PRIORITY, NULL);
    
    //setup timer
    
    xRetransmitTimer = xTimerCreate("ReTX", 250, pdFALSE, 0, vRetransmitTimerFunc);
    
    //grab the channel and device ID
    InitShiftIn(); //initialize shift register pins
    LTCHIn(); //latch input register
    GLOBAL_Channel = ShiftIn(); //grab channel
    GLOBAL_DeviceID = ShiftIn(); //grab DeviceID
    
    
    //setup modules
    
    COMMSetup();
    DSIOSetup();
    
    //done with pre-scheduler initialization, start scheduler
    vTaskStartScheduler();
    return (EXIT_SUCCESS);
}

void prvWiredInitTask( void * parameters )
{
    /* Wired Init - Runs Once
     * 1. take USART mutex
     * 2. flash indicators
     * 3. listen and wait for correct ping
     * 4. respond to ping with the generic ping response
     * 5. wait for TXC semaphore
     * 6. stop blinking lights
     * 7. set the init event group
     * 8. release the USART mutex
     * 9. suspend permanently
     */
    uint8_t PingResponse[4] = {0x7e, 0x02, 'R', GLOBAL_DeviceID};
    
    //take the mutex
    xSemaphoreTake(xUSART0_MUTEX, portMAX_DELAY);
    //start flashing indicators
    uint8_t FlashAll[3] = {'8', '8', 'F'}; //flash all segments
    xQueueSendToFront(xIND_Queue, FlashAll, portMAX_DELAY);
    
    //wait and listen for the correct ping
    uint8_t byte_buffer[1];
    uint8_t buffer[2];
    uint8_t received = 0;
    uint8_t length = 0;
    while(received != 1)
    {
        //wait for start delimiter
        xStreamBufferReceive(xCOMM_in_Stream, byte_buffer, 1, portMAX_DELAY);
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
        //check for ping
        if(buffer[0] == 'P')
        {
            if(buffer[1] == GLOBAL_DeviceID) //if pinging me, respond with ping response
            {
                //stop loop
                received = 1;
                //load output buffer
                xStreamBufferSend(xCOMM_out_Stream, PingResponse, 4, portMAX_DELAY);
                //enable transmitter
                RS485TR('T');
                //start transmission by setting TXCIE, and DREIE
                USART0.CTRLA |= USART_TXCIE_bm;
                USART0.CTRLA |= USART_DREIE_bm;
                //wait for semaphore
                xSemaphoreTake(xTXC, portMAX_DELAY);
                //stop flashing lights
                FlashAll[2] = 'O'; // O for Off
                xQueueSendToFront(xIND_Queue, FlashAll, portMAX_DELAY);
                //release MUTEX
                xSemaphoreGive(xUSART0_MUTEX);
                //set initialization flag
                xEventGroupSetBits(xEventInit, 0x1);
                //go to sleep until restart
                vTaskSuspend(NULL);
            }
        }
    }
}

void prvWLDTask( void * parameters )
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
    struct DeviceTracker DisplayTable[20]; //20 connected lights
    uint8_t numDisplays = 0;
    struct DeviceTracker SpecialTable[10]; //10 connected special devices (stop button etc)
    uint8_t numSpecials = 0;
    struct DeviceTracker MenuTable[5]; //5 connected menu devices
    uint8_t numMenus = 0;
    uint8_t buffer[MAX_MESSAGE_SIZE]; //messaging buffer
    uint8_t length = 0; //message length
    uint8_t updateIND = 0; //set when an indicator update should occur
    uint8_t DigitOne = 0x03; //0x03 will be used for OFF
    uint8_t DigitTwo = 0x03; //0x03 will be used for OFF
    
    /* High level overview
     * 1. check for any commands from timer or other internal source.
     * 2. check for command from the network
     * 3. set display if needed
     * 
     * since this is the lowest priority task, it shouldn't need to block for anything on the input side.
     */
    xEventGroupWaitBits(xEventInit, 0x1, pdFALSE, pdFALSE, portMAX_DELAY); //wait for init
    for(;;)
    {
        xSemaphoreTake(xNotify, 200); //wait for a message to come in from anywhere
        //internal source commands processing
        uint8_t breakloop = 0; //used to break the loop when yellow lockout is set
        while((xQueueReceive(xDeviceIN_Queue, buffer, 0) == pdTRUE) && (breakloop == 0))
        {
            //check message source
            switch(buffer[0])
            {    
                case 'T': //timers
                {
                    switch(buffer[1])
                    {
                        case 'J': //network join
                            //send the network join message
                            ; //this needs to be here to avoid an error on NetJoin.
                            uint8_t NetJoin[1] = {0xff};
                            xMessageBufferSend(xCOMM_out_Buffer, NetJoin, 1, 0);
                            xMessageBufferSend(xCOMM_out_Buffer, NetJoin, 1, 0);
                            xMessageBufferSend(xCOMM_out_Buffer, NetJoin, 1, 0);
                            break;
                    }
                }
                break;
                
                default:
                    break;
                //space for other intertask commands here
            }
            
        }
        //check for messages from COMMS
        length = 0;
        for(uint8_t i = 0; i < MAX_MESSAGE_SIZE; i++)
        {
            buffer[i] = 0;
        }
        length = xMessageBufferReceive(xDevice_Buffer, buffer, MAX_MESSAGE_SIZE, 0);
        if(length != 0) //if there is a message in the buffer
        {
            uint8_t router = 0; //byte used for routing from different sources
            //check device type in table and route to correct handling, this section is all just device checks
            switch(GLOBAL_DEVICE_TABLE[buffer[0]].Type)
            {
                case 'L': //wired lap controller
                    router = 'C'; //C for controller device
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
                    if(match != 1) //if no match found, add to table and check if the wireless address is matching anything
                    {
                        ControllerTable[numControllers].index = buffer[0];
                        tablePos = numControllers;
                        numControllers++;
                    }
                    //now the device is on the table, evaluate its message (if one is present)
                    if(length > 1)
                    {
                        //we either set digits according to what is sent, or we confirm response.
                        switch(buffer[1])
                        {
                            case 'U': //update message
                                DigitOne = buffer[2];
                                DigitTwo = buffer[3];
                                updateIND = 1;
                                //reply
                                buffer[0] = 'C'; //'C' specifies this as a confirmation
                                buffer[1] = DigitOne;
                                buffer[2] = DigitTwo;
                                buffer[3] = ControllerTable[tablePos].index;
                                xMessageBufferSend(xCOMM_out_Buffer, buffer, 4, 5);
                                break;
                        }
                    }
                }
                break;
                    
                case 'M': //menu (to be implemented)
                    
                    break;
            }
        }
        //message processing now complete, update display if needed.
        if(updateIND == 1)
        {
            {
                //set output to solid
                buffer[0] = DigitOne;
                buffer[1] = DigitTwo;
                buffer[2] = 'S'; //solid
                xQueueSendToBack(xIND_Queue, buffer, portMAX_DELAY);
            }
        }
        //loop and restart
    } 
}

void vRetransmitTimerFunc( TimerHandle_t xTimer )
{
    GLOBAL_RetransmissionTimerSet = 1;
}