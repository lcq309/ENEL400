/* 
 * RS 485 Lap count controller
 * Author:  Michael King
 * 
 * Created on July 2, 2024
 * 
 * This is the lap count controller, capable of controlling a lap count display
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
    uint8_t status;
};

//define global variables
uint8_t GLOBAL_DeviceID = 0;
uint8_t GLOBAL_Channel = 0;
uint8_t GLOBAL_DeviceType = 'L'; //Lap count controller, 'l' is the display.

#define mainWIREDINIT_TASK_PRIORITY (tskIDLE_PRIORITY + 1)
#define mainCOMMOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 4)
#define mainCOMMIN_TASK_PRIORITY (tskIDLE_PRIORITY + 3)
#define mainPBIN_TASK_PRIORITY (tskIDLE_PRIORITY + 4)
#define mainINDOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainWLC_TASK_PRIORITY (tskIDLE_PRIORITY + 1)

#define MaxNets 40

//task pointers

void prvWiredInitTask( void * parameters );
void prvWLCTask( void * parameters );

//retransmission timer

TimerHandle_t xRetransmitTimer;

//timer callback functions

void vRetransmitTimerFunc( TimerHandle_t xTimer );

//timer global

uint8_t GLOBAL_RetransmissionTimerSet = 1; //without setting this, it will never transmit

int main(int argc, char** argv) {
    
    //setup tasks
    xTaskCreate(prvWiredInitTask, "INIT", 300, NULL, mainWIREDINIT_TASK_PRIORITY, NULL);
    xTaskCreate(prvWLCTask, "WLC", 700, NULL, mainWLC_TASK_PRIORITY, NULL);
    
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
    uint8_t FlashAll[3] = {'1', '4', 'F'}; //flash all segments
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

void prvWLCTask( void * parameters )
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
    uint8_t LapNum = 0;
    uint8_t Requester = 0;
    uint8_t ForceCheck = 0; //used to force the device to check on the first go through.
    
    /* High level overview
     * 1. check for any commands from pushbutton or other internal source.
     * 2. check for any waiting messages.
     * 3. check timer for resending messages if applicable.
     * 4. resend messages if applicable
     * 5. set display
     * 
     * since this is the lowest priority task, it shouldn't need to block for anything on the input side.
     */
    xEventGroupWaitBits(xEventInit, 0x1, pdFALSE, pdFALSE, portMAX_DELAY); //wait for init
    for(;;)
    {
        xSemaphoreTake(xNotify, 200); //wait for a message to come in from anywhere
        //internal source commands processing
        while(xQueueReceive(xDeviceIN_Queue, buffer, 0) == pdTRUE)
        {
            //check message source
            switch(buffer[0])
            {
                case 'P': //pushbutton
                    //check the input against the current counter
                    switch(buffer[1])
                    {
                        case 'U': //increment
                            LapNum++;
                            if(DigitTwo == 'L') //only applicaple for last lap
                            {
                                DigitOne = 'F';
                                DigitTwo = 'N';
                            }
                            else
                            {
                                DigitOne = (LapNum / 10) + 0x30;
                                DigitTwo = (LapNum % 10) + 0x30; //should result in an ascii 0 through 9.
                            }
                            Requester = 1; //we are initiating this change
                            ForceCheck = 1;
                            updateIND = 1; //update the indicators
                            GLOBAL_RetransmissionTimerSet = 1; //update indicator checks immediately
                            break;

                        case 'D': //decrement
                            if(LapNum > 0)
                            {
                                LapNum--;
                                DigitOne = (LapNum / 10) + 0x30;
                                DigitTwo = (LapNum % 10) + 0x30; //should result in an ascii 0 through 9.
                            }
                            else if (LapNum == 0)
                            {
                                DigitOne = ' ';
                                DigitTwo = ' ';
                            }
                            else
                                LapNum = 0;
                            Requester = 1; //we are initiating this change
                            ForceCheck = 1;
                            updateIND = 1; //update the indicators
                            GLOBAL_RetransmissionTimerSet = 1; //update indicator checks immediately
                            break;

                        case 'H': //halfway
                            LapNum++;
                            DigitOne = 'H';
                            DigitTwo = 'F';
                            Requester = 1; //we are initiating this change
                            ForceCheck = 1;
                            updateIND = 1; //update the indicators
                            GLOBAL_RetransmissionTimerSet = 1; //update indicator checks immediately
                            break;
                            
                        case 'L': //last lap
                            LapNum++;
                            DigitOne = 'L';
                            DigitTwo = 'L';
                            Requester = 1; //we are initiating this change
                            ForceCheck = 1;
                            updateIND = 1; //update the indicators
                            GLOBAL_RetransmissionTimerSet = 1; //update indicator checks immediately
                            break;
                            
                        case 'Z': //zero
                            LapNum = 0;
                            DigitOne = '0';
                            DigitTwo = '0';
                            Requester = 1; //we are initiating this change
                            ForceCheck = 1;
                            updateIND = 1; //update the indicators
                            GLOBAL_RetransmissionTimerSet = 1; //update indicator checks immediately
                            break;
                    }
                    break;
                    
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
                    
                case 'l': //wired lap count display
                    router = 'D'; //D for display device
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
                            case 'C': //confirmation message
                                if((DigitOne == buffer[2]) && (DigitTwo == buffer[3]))
                                    ControllerTable[tablePos].status = 'C';
                                break;

                            case 'U': //update message
                                DigitOne = buffer[2];
                                DigitTwo = buffer[3];
                                Requester = 0;
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
                
                case 'D': //Display device, should only ever be confirming a change.
                    for(uint8_t i = 0; i < numDisplays; i++)
                    {
                        if(DisplayTable[i].index == buffer[0])
                        {
                            match = 1;
                            tablePos = i;
                            i = numDisplays;
                        }
                    }
                    if(match != 1) //if no match found, add to table
                    {
                        DisplayTable[numDisplays].index = buffer[0];
                        tablePos = numDisplays;
                        numDisplays++;
                    }
                    //Light device should now be on the table
                    if(length > 1)
                    {
                        switch(buffer[1])
                        {
                            default: //anything else should just be state confirmations
                                if((DigitOne == buffer[2]) && (DigitTwo == buffer[3]))
                                    DisplayTable[tablePos].status = 'C';
                                break;
                        }
                    }
                    break;
                    
                case 'M': //menu (to be implemented)
                    
                    break;
            }
        }
        //message processing now complete, check the status of any colour change request
        //if all colours are matching colour_req, then change colour_cur into colour_req
        uint8_t check_variable = 1;
        uint8_t NetSent[MaxNets];
        for(uint8_t i = 0; i < MaxNets; i++)
        {
            NetSent[i] = 0;
        }
        if(ForceCheck == 1) //if we are forcing a state check
        {
            for(uint8_t i = 0; i < numControllers; i++)
                ControllerTable[i].status = 0;
            for(uint8_t i = 0; i < numDisplays; i++)
                DisplayTable[i].status = 0;
            ForceCheck = 0;
        }
            switch(Requester)
            //how this acts depends on if it is a requester 1 or 2
            {
                
                case 1: //Lead Requester
                //check retransmission timers and retransmit if needed
                    if(GLOBAL_RetransmissionTimerSet == 1 && GLOBAL_MessageSent == 1)
                    {
                        //check other controllers
                        for(uint8_t i = 0; i < numControllers; i++)
                        {
                            if(ControllerTable[i].status != 'C')
                            {
                                for(uint8_t y = 0; y < MaxNets; y++)
                                {
                                    if(NetSent[y] == 0) //if a null is found, end the loop early and send the message
                                    {
                                        y = MaxNets;
                                        //send another colour change request, and set check_variable
                                        buffer[0] = 'U'; //'U' specifies this as an update command
                                        buffer[1] = DigitOne;
                                        buffer[2] = DigitTwo;
                                        buffer[3] = ControllerTable[i].index;
                                        check_variable = 0;
                                        NetSent[y] = GLOBAL_DEVICE_TABLE[ControllerTable[i].index].Net; //update NetSent table
                                        xMessageBufferSend(xCOMM_out_Buffer, buffer, 4, 5);
                                    }
                                    else if(NetSent[y] == GLOBAL_DEVICE_TABLE[ControllerTable[i].index].Net) //already sent to this network, do not transmit
                                    {
                                        //just end loop and move on to next device in table
                                        y = MaxNets;
                                    }
                                }
                            }
                        }
                        //check lights
                        for(uint8_t i = 0; i < numDisplays; i++)
                        {
                            if(DisplayTable[i].status != 'C')
                            {
                                for(uint8_t y = 0; y < MaxNets; y++)
                                {
                                    if(NetSent[y] == 0) //if a null is found, end the loop early and send the message
                                    {
                                        y = MaxNets;
                                        //send another colour change request, and set check_variable
                                        buffer[0] = 'U'; //'U' specifies this as an update command
                                        buffer[1] = DigitOne;
                                        buffer[2] = DigitTwo;
                                        buffer[3] = DisplayTable[i].index;
                                        check_variable = 0;
                                        NetSent[y] = GLOBAL_DEVICE_TABLE[DisplayTable[i].index].Net; //update NetSent table
                                        xMessageBufferSend(xCOMM_out_Buffer, buffer, 4, 5);
                                    }
                                    else if(NetSent[y] == GLOBAL_DEVICE_TABLE[DisplayTable[i].index].Net) //already sent to this network, do not transmit
                                    {
                                        //just end loop and move on to next device in table
                                        y = MaxNets;
                                    }
                                }
                            }
                        }
                        //if all devices are matching, we can stop blinking the display
                        if(check_variable == 1)
                        {
                            Requester = 0;
                            updateIND = 1;
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
        //at this point, all controllers and displays have confirmed the numbers, we can update our own display.
        //update indicators if needed
        if(updateIND == 1)
        {
            if(Requester == 1)
            {
                //set output to flashing
                buffer[0] = DigitOne;
                buffer[1] = DigitTwo;
                buffer[2] = 'F'; //flash
                xQueueSendToBack(xIND_Queue, buffer, portMAX_DELAY);
            }
            else
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