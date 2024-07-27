/* 
 * RS 485 Stop Light
 * Author:  Michael King
 * 
 * Created on June 26, 2024
 * 
 * This is meant to be a stop card, it controls all lights and controllers on the network in an emergency situation.
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
uint8_t GLOBAL_Channel = 0xff;
uint8_t GLOBAL_DeviceType = 'S';

#define mainWIREDINIT_TASK_PRIORITY (tskIDLE_PRIORITY + 1)
#define mainCOMMOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 4)
#define mainCOMMIN_TASK_PRIORITY (tskIDLE_PRIORITY + 3)
#define mainPBIN_TASK_PRIORITY (tskIDLE_PRIORITY + 4)
#define mainINDOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainWSB_TASK_PRIORITY (tskIDLE_PRIORITY + 1)

#define MaxNets 40

//task pointers

void prvWiredInitTask( void * parameters );
void prvWSBTask( void * parameters );

//retransmission timer

TimerHandle_t xRetransmitTimer;

//timer callback functions

void vRetransmitTimerFunc( TimerHandle_t xTimer );

//timer global

uint8_t GLOBAL_RetransmissionTimerSet = 1; //without setting this, it will never transmit

int main(int argc, char** argv) {
    
    //setup tasks
    xTaskCreate(prvWiredInitTask, "INIT", 300, NULL, mainWIREDINIT_TASK_PRIORITY, NULL);
    xTaskCreate(prvWSBTask, "WSB", 700, NULL, mainWSB_TASK_PRIORITY, NULL);
    
    //setup timer
    
    xRetransmitTimer = xTimerCreate("ReTX", 750, pdFALSE, 0, vRetransmitTimerFunc);
    
    //grab the channel and device ID
    InitShiftIn(); //initialize shift register pins
    LTCHIn(); //latch input register
    ShiftIn(); //grab channel and discard
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
    uint8_t FlashAll[2] = {0xff, 'F'};
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
                FlashAll[1] = 'O'; // O for Off
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

void prvWSBTask( void * parameters )
{
    /* Wired Stop Button
     * maintain a table of controller and light indexes, with a confirmation marker
     * communicate with other stop buttons on the same channel for coordination
     * stop button is responsible for releasing red lockout at the director's discretion
     * stop button will release the yellow lockout when all lights, controllers, and stop buttons have confirmed
     * 
     */
    struct DeviceTracker ControllerTable[30]; //maximum of 30 connected controlled devices (probably not a hard limit)
    uint8_t numControllers = 0;
    uint8_t tablePos = 0;
    struct DeviceTracker LightTable[30]; //30 connected lights
    uint8_t numLights = 0;
    struct DeviceTracker SpecialTable[10]; //10 connected special devices (stop button etc)
    uint8_t numSpecials = 0;
    struct DeviceTracker MenuTable[5]; //5 connected menu devices
    uint8_t numMenus = 0;
    volatile uint8_t lockout = 'C'; //used to track lockout status ('R'ed, 'Y'ellow, 'C'lear)
    uint8_t buffer[MAX_MESSAGE_SIZE]; //messaging buffer
    uint8_t length = 0; //message length
    uint8_t updateIND = 0; //set when an indicator update should occur
    uint8_t colour_req = 'Y'; //requested colour
    volatile uint8_t colour_cur = 'Y'; //current confirmed colour
    volatile uint8_t colour_err = 0; //error tracking colour
    uint8_t Requester = 0; //is this device currently requesting a colour change
    uint8_t ForceCheck = 0; //used to force the device to check on the first go through.
    
    /* High level overview
     * 1. check for any commands from pushbutton
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
        xSemaphoreTake(xNotify, 200); //wait for a message to come in from anywhere
        //internal source commands processing
        uint8_t breakloop = 0; //used to break the loop when yellow lockout is set
        while((xQueueReceive(xDeviceIN_Queue, buffer, 0) == pdTRUE) && (breakloop == 0))
        {
            //check message source
            switch(buffer[0])
            {
                case 'P': //pushbutton
                    //this is a bit different from the normal controller, since this has the option of red, yellow, or off.
                    //off can override yellow, and serves as an escape if something is going wrong with this part
                    //yellow overrides red, but off cannot override red, only yellow.
                    
                    switch(lockout)
                    {
                        case 'C': //clear, allow colour change request
                            if(buffer[1] == 'O')
                            {
                                lockout = 'C';
                                colour_cur = 0;
                            }
                            else
                                lockout = buffer[1];
                            colour_req = buffer[1];
                            updateIND = 1; //update the indicators
                            GLOBAL_RetransmissionTimerSet = 1; //update indicator checks immediately
                            GLOBAL_MessageSent = 1;
                            ForceCheck = 1;
                            Requester = 1;
                            break;
                        
                        case 'y': //yellow lockout clearing
                        case 'Y': //yellow lockout, yield to red or off
                            if(buffer[1] == 'R')
                                lockout = 'R';
                            else if(buffer[1] == 'O')
                                lockout = 'C';
                            colour_req = buffer[1];
                            Requester = 1;
                            ForceCheck = 1;
                            updateIND = 1; //update the indicators
                            GLOBAL_RetransmissionTimerSet = 1; //update indicator checks immediately
                            GLOBAL_MessageSent = 1;
                            break;
                        
                        case 'r': //red lockout clearing
                            if(buffer[1] == 'R')
                            {
                                lockout = 'R';
                                colour_req = buffer[1];
                                Requester = 1;
                                ForceCheck = 1;
                                GLOBAL_RetransmissionTimerSet = 1; //update indicator checks immediately
                                GLOBAL_MessageSent = 1;
                                updateIND = 1;
                            }
                        case 'R': //red lockout, flash red for a short time for off, yellow will override
                            if(buffer[1] == 'O')
                            {
                                buffer[0] = 'R';
                                buffer[1] = 'W'; //warning flash red
                                xQueueSendToFront(xIND_Queue, buffer, portMAX_DELAY);
                                updateIND = 1;
                            }
                            else if(buffer[1] == 'Y')
                            {
                                colour_req = 'Y';
                                lockout = 'r'; //button released, other checks need to happen before anything else can occur
                                GLOBAL_RetransmissionTimerSet = 1; //update indicator checks immediately
                                GLOBAL_MessageSent = 1;
                                updateIND = 1;
                            }
                            else if(buffer[1] == 'R')
                            {
                                lockout = 'R';
                                colour_req = buffer[1];
                                Requester = 1;
                                ForceCheck = 1;
                                GLOBAL_RetransmissionTimerSet = 1; //update indicator checks immediately
                                GLOBAL_MessageSent = 1;
                                updateIND = 1;
                            }
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
        length = xMessageBufferReceive(xDevice_Buffer, buffer, MAX_MESSAGE_SIZE, 0);
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
                    
                case '5': //pit controller
                    router = 'C';
                    break;
                    
                case '6': //pit light
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
                    //controllers should only ever be confirming state
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
                        switch(buffer[1])
                        {
                            case 'E': //error?
                                break;
                                
                            default: //status confirmation
                                ControllerTable[tablePos].status = (buffer[1] - 32);
                                break;
                        }
                            
                    }
                }
                break;
                
                case 'L': //light device, should only ever be confirming colours or giving an error response
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
                    if(length > 1)
                    {
                        switch(buffer[1])
                        {
                            case 'E': //Error messages?
                                colour_err = buffer[2];
                                updateIND = 1;
                                break;

                            default: //anything else should just be state confirmations
                                LightTable[tablePos].status = (buffer[1] - 32); //subtract 32 to get uppercase letter
                                break;
                        }
                    }
                    break;
                    
                case 'S': //special device, stop button and etc. we need to work together, record the state and use it to set our own.
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
                    if(length > 1)
                    {
                        switch(buffer[1])
                        {
                            case 'R': //red request, we are required to indicate red, lockout depends on button state
                                if(lockout != 'R') //if we have not already pressed the stop button, just update state
                                {
                                    lockout = 'r'; //unpressed button, red lockout
                                    colour_req = 'R'; //request red
                                    Requester = 2;
                                    buffer[0] = 'x'; //confirm red release state
                                }
                                else //we are also stopped, update the state of the stop button and respond in kind
                                {
                                    buffer[0] = 'r'; //confirm red locked state
                                }
                                SpecialTable[tablePos].status = 'R';
                                updateIND = 1;
                                buffer[1] = SpecialTable[tablePos].index;
                                xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                break;
                                
                            case 'r': //this is a response, this tells that the button is currently pressed.
                                //update the state of the stop button
                                SpecialTable[tablePos].status = 'R';
                                break;
                                
                            case 'x': //this is a response, this tells that the button is currently released.
                                SpecialTable[tablePos].status = 'r'; //lowercase r means the button is released.
                                break;

                            case 'Y': //if they are trying to signal yellow before we are ready to release, take over the network
                                //this shouldn't really happen as they are supposed to negotiate together before attempting to release
                                if(lockout == 'R')
                                {
                                    buffer[0] = 'R'; //take control of the network
                                    buffer[1] = SpecialTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                    ForceCheck = 1;
                                    Requester = 1;
                                }
                                else //we are ready to release
                                {
                                    buffer[0] = 'y'; //confirm yellow, and release red lockout
                                    buffer[1] = SpecialTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                    lockout = 'Y';
                                    colour_req = 'Y';
                                    colour_cur = 'O';
                                    updateIND = 1;
                                }
                                break;
                            case 'y': //this is a response, mark status
                                SpecialTable[tablePos].status = 'Y';
                                break;
                            case 'o': //off command response
                                SpecialTable[tablePos].status = 'O';
                                break;
                            case 'O': //off command, overrides any normal colour change logic (unless we are RED)
                                if(lockout != 'R')
                                {
                                    lockout = 'C';
                                    colour_req = 'O';
                                    colour_cur = 'O';
                                    Requester = 2;
                                    updateIND = 1;
                                    buffer[0] = 'o'; //confirm off
                                    buffer[1] = SpecialTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                }
                                else if(lockout == 'R') //we are not ready to release
                                {
                                    lockout = 'R';
                                    colour_req = 'R';
                                    buffer[0] = 'R'; //take control of the network
                                    buffer[1] = SpecialTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                    GLOBAL_RetransmissionTimerSet = 1;
                                    updateIND = 1;
                                    ForceCheck = 1;
                                }
                                break;

                            case 'C': //Clear command, issued after yellow lockout is released.
                                //can't clear directly from red, the yellow transition needs to be complete first
                                //should never try to clear on red, stop buttons will query each other before attempting to release
                                 if(lockout != 'R')
                                {
                                    lockout = 'C';
                                    colour_req = 'O';
                                    colour_cur = 'O';
                                    Requester = 2;
                                    updateIND = 1;
                                    buffer[0] = 'o'; //confirm off
                                    buffer[1] = SpecialTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                }
                                else if(lockout == 'R') //we are not ready to release
                                {
                                    lockout = 'R';
                                    colour_req = 'R';
                                    buffer[0] = 'R'; //take control of the network
                                    buffer[1] = SpecialTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                    GLOBAL_RetransmissionTimerSet = 1;
                                    updateIND = 1;
                                    ForceCheck = 1;
                                }
                                break;
                        }
                    }
                    break;
                    
                case 'M': //menu (to be implemented)
                    
                    break;
            }
        }
        //message processing now complete, check the status of any colour change request
        //if not all devices have confirmed for red or yellow, keep trying
        //only the yellow lockout needs to be released, the red lockout is controlled manually
        //red lockout can only be released if all stop buttons are in agreement
        //if we are attempting to release (lockout 'r'), query the state of the other stop buttons
        //if all stop buttons are ready to release, set lockout level to yellow
        uint8_t check_variable = 1;
        uint8_t NetSent[MaxNets];
        for(uint8_t i = 0; i < MaxNets; i++)
        {
            NetSent[i] = 0;
        }
        if(ForceCheck == 1) //if we are forcing a state check
        {
            for(uint8_t i = 0; i < numSpecials; i++)
                SpecialTable[i].status = 0;
            for(uint8_t i = 0; i < numControllers; i++)
                ControllerTable[i].status = 0;
            for(uint8_t i = 0; i < numLights; i++)
                LightTable[i].status = 0;
            ForceCheck = 0;
        }
        if((colour_cur != colour_req) && (colour_cur != (colour_req + 32))) //this also allows the lowercase through, since it will only be the lowercase form once all devices have confirmed.
        {
            switch(Requester)
            //how this acts depends on what colour is requested
            {
                case 1: //Lead Requester
                    //for lockout 'R', turn lights red
                    //for lockout 'r', check other stop buttons and change to yellow
                    //for lockout 'Y', normal controller behaviour down to 'C'
                    //for colour_req 'O', turn everything off
                    //check retransmission timers and retransmit if needed
                    if((GLOBAL_RetransmissionTimerSet == 1) && (GLOBAL_MessageSent == 1))
                    {
                        if((lockout == 'R') && (Requester == 1))
                        {
                            for(uint8_t i = 0; i < numSpecials; i++)
                            {
                                if((SpecialTable[i].status != 'R') && (SpecialTable[i].status != 'r'))
                                {
                                    for(uint8_t y = 0; y < MaxNets; y++)
                                    {
                                        if(NetSent[y] == 0) //if a null is found, end the loop early and send the message
                                        {
                                            y = MaxNets;
                                            //send another colour change request, and set check_variable
                                            buffer[0] = colour_req; //colour_req is the colour we are requesting
                                            buffer[1] = SpecialTable[i].index; //load with retransmission request
                                            check_variable = 0;
                                            NetSent[y] = GLOBAL_DEVICE_TABLE[SpecialTable[i].index].Net; //update NetSent table
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                        }
                                        else if(NetSent[y] == GLOBAL_DEVICE_TABLE[SpecialTable[i].index].Net) //already sent to this network, do not transmit
                                        {
                                            //just end loop and move on to next device in table
                                            y = MaxNets;
                                        }
                                    }
                                }
                            }
                            for(uint8_t i = 0; i < numControllers; i++)
                            {
                                if(ControllerTable[i].status != 'R')
                                {
                                    for(uint8_t y = 0; y < MaxNets; y++)
                                    {
                                        if(NetSent[y] == 0) //if a null is found, end the loop early and send the message
                                        {
                                            y = MaxNets;
                                            //send another colour change request, and set check_variable
                                            buffer[0] = 'R'; //colour_req is the colour we are requesting
                                            buffer[1] = ControllerTable[i].index; //load with retransmission request
                                            check_variable = 0;
                                            NetSent[y] = GLOBAL_DEVICE_TABLE[ControllerTable[i].index].Net; //update NetSent table
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                        }
                                        else if(NetSent[y] == GLOBAL_DEVICE_TABLE[ControllerTable[i].index].Net) //already sent to this network, do not transmit
                                        {
                                            //just end loop and move on to next device in table
                                            y = MaxNets;
                                        }
                                    }
                                }
                            }
                            for(uint8_t i = 0; i < numLights; i++)
                            {
                                if(LightTable[i].status != 'R')
                                {
                                    for(uint8_t y = 0; y < MaxNets; y++)
                                    {
                                        if(NetSent[y] == 0) //if a null is found, end the loop early and send the message
                                        {
                                            y = MaxNets;
                                            //send another colour change request, and set check_variable
                                            buffer[0] = 'R'; //colour_req is the colour we are requesting
                                            buffer[1] = LightTable[i].index; //load with retransmission request
                                            check_variable = 0;
                                            NetSent[y] = GLOBAL_DEVICE_TABLE[LightTable[i].index].Net; //update NetSent table
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                        }
                                        else if(NetSent[y] == GLOBAL_DEVICE_TABLE[LightTable[i].index].Net) //already sent to this network, do not transmit
                                        {
                                            //just end loop and move on to next device in table
                                            y = MaxNets;
                                        }
                                    }
                                }
                            }
                            if(check_variable == 1)
                            {
                                colour_cur = 'R';
                                updateIND = 1;
                            }
                            //reset transmission timer, might also add a separate check to ensure that a transmission has actually occurred.
                            else // if something was transmitted, we need to reset the timer.
                            {
                                GLOBAL_RetransmissionTimerSet = 0;
                                xTimerReset(xRetransmitTimer, portMAX_DELAY);
                            }
                        }
                        else if((lockout == 'r') && (Requester == 1))
                        {
                            check_variable = 1;
                            //check the state of the other stop buttons
                            for(uint8_t i = 0; i < numSpecials; i++)
                            {
                                if(SpecialTable[i].status != 'r')
                                {
                                    for(uint8_t y = 0; y < MaxNets; y++)
                                    {
                                        if(NetSent[y] == 0) //if a null is found, end the loop early and send the message
                                        {
                                            y = MaxNets;
                                            //send another colour change request, and set check_variable
                                            buffer[0] = 'R'; //R is how we can query the state
                                            buffer[1] = SpecialTable[i].index; //load with retransmission request
                                            check_variable = 0;
                                            NetSent[y] = GLOBAL_DEVICE_TABLE[SpecialTable[i].index].Net; //update NetSent table
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                        }
                                        else if(NetSent[y] == GLOBAL_DEVICE_TABLE[SpecialTable[i].index].Net) //already sent to this network, do not transmit
                                        {
                                            //just end loop and move on to next device in table
                                            y = MaxNets;
                                        }
                                    }
                                }
                            }
                            if(check_variable == 1) //move to yellow lockout
                            {
                                lockout = 'Y';
                                updateIND = 1;
                                colour_req = 'Y';
                            }
                            else // if something was transmitted, we need to reset the timer.
                            {
                                GLOBAL_RetransmissionTimerSet = 0;
                                xTimerReset(xRetransmitTimer, portMAX_DELAY);
                            }
                        }
                        else if((colour_req == 'O') && (lockout != 'R'))
                        {
                            for(uint8_t i = 0; i < numSpecials; i++)
                            {
                                if(SpecialTable[i].status != 'O')
                                {
                                    for(uint8_t y = 0; y < MaxNets; y++)
                                    {
                                        if(NetSent[y] == 0) //if a null is found, end the loop early and send the message
                                        {
                                            y = MaxNets;
                                            //send another colour change request, and set check_variable
                                            buffer[0] = colour_req; //colour_req is the colour we are requesting
                                            buffer[1] = ControllerTable[i].index; //load with retransmission request
                                            check_variable = 0;
                                            NetSent[y] = GLOBAL_DEVICE_TABLE[SpecialTable[i].index].Net; //update NetSent table
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                        }
                                        else if(NetSent[y] == GLOBAL_DEVICE_TABLE[SpecialTable[i].index].Net) //already sent to this network, do not transmit
                                        {
                                            //just end loop and move on to next device in table
                                            y = MaxNets;
                                        }
                                    }
                                }
                            }
                            for(uint8_t i = 0; i < numControllers; i++)
                            {
                                if(ControllerTable[i].status != 'O')
                                {
                                    for(uint8_t y = 0; y < MaxNets; y++)
                                    {
                                        if(NetSent[y] == 0) //if a null is found, end the loop early and send the message
                                        {
                                            y = MaxNets;
                                            //send another colour change request, and set check_variable
                                            buffer[0] = colour_req; //colour_req is the colour we are requesting
                                            buffer[1] = ControllerTable[i].index; //load with retransmission request
                                            check_variable = 0;
                                            NetSent[y] = GLOBAL_DEVICE_TABLE[ControllerTable[i].index].Net; //update NetSent table
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                        }
                                        else if(NetSent[y] == GLOBAL_DEVICE_TABLE[ControllerTable[i].index].Net) //already sent to this network, do not transmit
                                        {
                                            //just end loop and move on to next device in table
                                            y = MaxNets;
                                        }
                                    }
                                }
                            }
                            for(uint8_t i = 0; i < numLights; i++)
                            {
                                if(LightTable[i].status != 'O')
                                {
                                    for(uint8_t y = 0; y < MaxNets; y++)
                                    {
                                        if(NetSent[y] == 0) //if a null is found, end the loop early and send the message
                                        {
                                            y = MaxNets;
                                            //send another colour change request, and set check_variable
                                            buffer[0] = colour_req; //colour_req is the colour we are requesting
                                            buffer[1] = LightTable[i].index; //load with retransmission request
                                            check_variable = 0;
                                            NetSent[y] = GLOBAL_DEVICE_TABLE[LightTable[i].index].Net; //update NetSent table
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                        }
                                        else if(NetSent[y] == GLOBAL_DEVICE_TABLE[LightTable[i].index].Net) //already sent to this network, do not transmit
                                        {
                                            //just end loop and move on to next device in table
                                            y = MaxNets;
                                        }
                                    }
                                }
                            }
                            if(check_variable == 1)
                            {
                                colour_cur = colour_req;
                                updateIND = 1;
                            }
                            //reset transmission timer, might also add a separate check to ensure that a transmission has actually occurred.
                            else // if something was transmitted, we need to reset the timer.
                            {
                                GLOBAL_RetransmissionTimerSet = 0;
                                xTimerReset(xRetransmitTimer, portMAX_DELAY);
                            }
                        }
                        else if(lockout == 'Y')
                        {
                        //check all controllers, lights, and stop buttons
                        //retransmit to any that haven't acknowledged the change yet
                        //set colour_cur to 'Y' once they have all confirmed
                        for(uint8_t i = 0; i < numSpecials; i++)
                            {
                                if(SpecialTable[i].status != 'Y')
                                {
                                    for(uint8_t y = 0; y < MaxNets; y++)
                                    {
                                        if(NetSent[y] == 0) //if a null is found, end the loop early and send the message
                                        {
                                            y = MaxNets;
                                            //send another colour change request, and set check_variable
                                            buffer[0] = 'Y';
                                            buffer[1] = SpecialTable[i].index; //load with retransmission request
                                            check_variable = 0;
                                            NetSent[y] = GLOBAL_DEVICE_TABLE[SpecialTable[i].index].Net; //update NetSent table
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                        }
                                        else if(NetSent[y] == GLOBAL_DEVICE_TABLE[SpecialTable[i].index].Net) //already sent to this network, do not transmit
                                        {
                                            //just end loop and move on to next device in table
                                            y = MaxNets;
                                        }
                                    }
                                }
                            }
                        for(uint8_t i = 0; i < numControllers; i++)
                            {
                                if(ControllerTable[i].status != colour_req)
                                {
                                    for(uint8_t y = 0; y < MaxNets; y++)
                                    {
                                        if(NetSent[y] == 0) //if a null is found, end the loop early and send the message
                                        {
                                            y = MaxNets;
                                            //send another colour change request, and set check_variable
                                            buffer[0] = colour_req; //colour_req is the colour we are requesting
                                            buffer[1] = ControllerTable[i].index; //load with retransmission request
                                            check_variable = 0;
                                            NetSent[y] = GLOBAL_DEVICE_TABLE[ControllerTable[i].index].Net; //update NetSent table
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
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
                        for(uint8_t i = 0; i < numLights; i++)
                            {
                                if(LightTable[i].status != colour_req)
                                {
                                    for(uint8_t y = 0; y < MaxNets; y++)
                                    {
                                        if(NetSent[y] == 0) //if a null is found, end the loop early and send the message
                                        {
                                            y = MaxNets;
                                            //send another colour change request, and set check_variable
                                            buffer[0] = colour_req; //colour_req is the colour we are requesting
                                            buffer[1] = LightTable[i].index; //load with retransmission request
                                            check_variable = 0;
                                            NetSent[y] = GLOBAL_DEVICE_TABLE[LightTable[i].index].Net; //update NetSent table
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                        }
                                        else if(NetSent[y] == GLOBAL_DEVICE_TABLE[LightTable[i].index].Net) //already sent to this network, do not transmit
                                        {
                                            //just end loop and move on to next device in table
                                            y = MaxNets;
                                        }
                                    }
                                }
                            }
                            //if all colours are matching, we can set colour_cur to colour_req
                            if(check_variable == 1)
                            {
                                colour_cur = colour_req;
                                updateIND = 1;
                            }
                            //reset transmission timer, might also add a separate check to ensure that a transmission has actually occurred.
                            else // if something was transmitted, we need to reset the timer.
                            {
                                GLOBAL_RetransmissionTimerSet = 0;
                                xTimerReset(xRetransmitTimer, portMAX_DELAY);
                            }
                        }
                    }
                    break;
                        
                case 2: //Subordinate Requester, not yet implemented
                    /*if(GLOBAL_RetransmissionTimerSet == 1)
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
                    }*/
                    break;
                        
                case 0: //just do nothing if we are not set to request anything
                    break;
            }
        }
        check_variable = 1;
        //if we are requester 1, we should ensure that first the controller lockouts are released
        //as a requester 2, we can return to requester 0 once all lights have confirmed colour
        //at this point, all lights and controllers have confirmed colour change, so we need to start releasing lockouts
        if((lockout == 'Y') || (lockout == 'y'))
        {
            switch(Requester)
            {
                case 1:
                    if((lockout == colour_cur) && (GLOBAL_RetransmissionTimerSet == 1) && (GLOBAL_MessageSent == 1)) //at this point, all devices have confirmed change and we should start releasing lockouts
                    {
                        for(uint8_t i = 0; i < numSpecials; i++)
                            {
                                if(SpecialTable[i].status != 'C')
                                {
                                    for(uint8_t y = 0; y < MaxNets; y++)
                                    {
                                        if(NetSent[y] == 0) //if a null is found, end the loop early and send the message
                                        {
                                            y = MaxNets;
                                            //send another colour change request, and set check_variable
                                            buffer[0] = 'C';
                                            buffer[1] = SpecialTable[i].index; //load with retransmission request
                                            check_variable = 0;
                                            NetSent[y] = GLOBAL_DEVICE_TABLE[SpecialTable[i].index].Net; //update NetSent table
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                        }
                                        else if(NetSent[y] == GLOBAL_DEVICE_TABLE[SpecialTable[i].index].Net) //already sent to this network, do not transmit
                                        {
                                            //just end loop and move on to next device in table
                                            y = MaxNets;
                                        }
                                    }
                                }
                                if(ControllerTable[i].status != 'C')
                                {
                                    for(uint8_t y = 0; y < MaxNets; y++)
                                    {
                                        if(NetSent[y] == 0) //if a null is found, end the loop early and send the message
                                        {
                                            //send another clear request, and set check_variable
                                            buffer[0] = 'C';
                                            buffer[1] = colour_req; //colour_req is the colour we are requesting
                                            buffer[2] = ControllerTable[i].index; //load with retransmission request
                                            check_variable = 0;
                                            NetSent[y] = GLOBAL_DEVICE_TABLE[ControllerTable[i].index].Net; //update NetSent table
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 3, 5);
                                            y = MaxNets;
                                        }
                                        else if(NetSent[y] == GLOBAL_DEVICE_TABLE[ControllerTable[i].index].Net) //already sent to this network, do not transmit
                                        {
                                            //just end loop and move on to next device in table
                                            y = MaxNets;
                                        }
                                    }
                                }
                            }
                        //if all controllers are confirmed, we can move on to releasing lights
                        if(check_variable == 1)
                        {
                            lockout = lockout + 32; //switch to lowercase lockout letter
                            updateIND = 1;
                        }
                        //reset transmission timer, might also add a separate check to ensure that a transmission has actually occurred.
                        else // if something was transmitted, we need to reset the timer.
                        {
                            GLOBAL_RetransmissionTimerSet = 0;
                            xTimerReset(xRetransmitTimer, portMAX_DELAY);
                        }
                    }
                    if((lockout == (colour_cur + 32) && (GLOBAL_RetransmissionTimerSet == 1) && (GLOBAL_MessageSent == 1))) //at this point, all controllers have confirmed lockout release
                    {
                        //we can begin releasing the lights
                        for(uint8_t i = 0; i < numLights; i++)
                        {
                            if(LightTable[i].status != 'C') //if not confirmed cleared
                            {
                                    for(uint8_t y = 0; y < MaxNets; y++)
                                    {
                                        if(NetSent[y] == 0) //if a null is found, end the loop early and send the message
                                        {
                                            //send another clear request, and set check_variable
                                            buffer[0] = 'C';
                                            buffer[1] = colour_req; //colour_req is the colour we are requesting
                                            buffer[2] = LightTable[i].index; //load with retransmission request
                                            check_variable = 0;
                                            NetSent[y] = GLOBAL_DEVICE_TABLE[LightTable[i].index].Net; //update NetSent table
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 3, 5);
                                            y = MaxNets;
                                        }
                                        else if(NetSent[y] == GLOBAL_DEVICE_TABLE[LightTable[i].index].Net) //already sent to this network, do not transmit
                                        {
                                            //just end loop and move on to next device in table
                                            y = MaxNets;
                                        }
                                    }
                            }
                        }
                        //if all controllers and lights are confirmed, we can release internal lockout and return to requester 0
                        //but there is a special case for blue, where we should return the lights to green after a delay.
                        //this needs some more discussion
                        if(check_variable == 1)
                        {
                            lockout = 'C';
                            colour_req = colour_cur;
                            updateIND = 1;
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
        }
        //update indicators if needed
        if(updateIND == 1)
        {
            if(colour_cur != colour_req)
            {
                //set both to flash
                //discard errors here
                colour_err = 0;
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
            else if(colour_err == colour_cur)
            {
                if(colour_cur == 'O')
                {
                    //blink all indicators, if a light hasn't turned off
                    //set single light flash to show all devices have confirmed change but are still releasing lights
                    buffer[0] = 0xff; //all indicators
                    buffer[1] = 'O'; //off
                    xQueueSendToBack(xIND_Queue, buffer, portMAX_DELAY);
                    buffer[0] = 0xff;
                    buffer[1] = 'B'; //blink
                    xQueueSendToBack(xIND_Queue, buffer, portMAX_DELAY);
                }
                else
                {
                    //set single light flash to show all devices have confirmed change but are still releasing lights
                    buffer[0] = 0xff; //all indicators
                    buffer[1] = 'O'; //off
                    xQueueSendToBack(xIND_Queue, buffer, portMAX_DELAY);
                    buffer[0] = colour_cur;
                    buffer[1] = 'B'; //blink
                    xQueueSendToBack(xIND_Queue, buffer, portMAX_DELAY);
                }
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

void vRetransmitTimerFunc( TimerHandle_t xTimer )
{
    GLOBAL_RetransmissionTimerSet = 1;
}