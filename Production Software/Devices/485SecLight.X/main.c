/* 
 * RS 485 Sector Light
 * Author:  Michael King
 * 
 * Created on April 26, 2024
 * 
 * This is meant to be a generic Sector Light on the wired network
 * which means that it drives a light with either 3 or 4 colours
 * there is a physical way to check which one this is.
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

//define device tracking struct, only needs an index for lights
struct DeviceTracker 
{
    uint8_t index;
};

//define global variables
uint8_t GLOBAL_DeviceID = 0;
uint8_t GLOBAL_Channel = 0;
uint8_t GLOBAL_DeviceType = '3'; //Generic Sector Light: Wired Light

#define mainWIREDINIT_TASK_PRIORITY (tskIDLE_PRIORITY + 4)
#define mainCOMMOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 3)
#define mainCOMMIN_TASK_PRIORITY (tskIDLE_PRIORITY + 4)
#define mainPBIN_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainINDOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainWSC_TASK_PRIORITY (tskIDLE_PRIORITY + 1)

//task pointers

void prvWiredInitTask( void * parameters );
void prvWSLTask( void * parameters );

int main(int argc, char** argv) {
    
    //setup tasks
    xTaskCreate(prvWiredInitTask, "INIT", 300, NULL, mainWIREDINIT_TASK_PRIORITY, NULL);
    xTaskCreate(prvWSCTask, "WSC", 600, NULL, mainWSC_TASK_PRIORITY, NULL);
    
    //setup modules
    
    COMMSetup();
    DSIOSetup();
    
    //setup timer
    
    xRetransmitTimer = xTimerCreate("ReTX", 500, pdFALSE, 0, vRetransmitTimerFunc);
    
    //grab the channel and device ID
    InitShiftIn(); //initialize shift register pins
    LTCHIn(); //latch input register
    GLOBAL_Channel = ShiftIn(); //grab channel
    GLOBAL_DeviceID = ShiftIn(); //grab DeviceID
    
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
    xQueueSendToBack(xIND_Queue, FlashAll, portMAX_DELAY);
    
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
                xQueueSendToBack(xIND_Queue, FlashAll, portMAX_DELAY);
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

void prvWSLTask( void * parameters )
{
    /* Wired Sector light
     * maintain a table of controller indexes to easily send replies
     * doesn't need to store controller information
     * reply when a controller tries to set colour
     * Stop button has special power, can override any lockout at any time
     * (i.e. Red to Yellow or off)
     * 
     */
    struct DeviceTracker ControllerTable[20]; //maximum of 20 connected controlled devices (probably not a hard limit)
    uint8_t numControllers = 0;
    uint8_t tablePos = 0;
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
    uint8_t responded = 0; //track if we have responded or not
    
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
            //check message source (light check message will come here)
            switch(buffer[0])
            {
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
                            //if there is no lockout, try to change the colour blue and confirm blue with all controllers on the list.
                            switch(lockout)
                            {
                                case 'C': //Clear, try to change colour, response is handled later
                                    updateIND = 1;
                                    colour_req = 'B';
                                    lockout = 'B';
                                    break;
                                    
                                default: //if there is a lockout, just ignore
                                    break;
                            }
                            break;
                            
                        case 'G': //Green colour change request
                            //if we are requesting blue, green will override it
                            switch(lockout)
                            {
                                case 'C': //no lockout, this is a green request from a controller
                                    //set lockout and colour_req to green, response is handled later
                                    updateIND = 1;
                                    lockout = 'G';
                                    colour_req = 'G';
                                    break;
                                
                                case 'B': //blue lockout will be overridden
                                    updateIND = 1;
                                    lockout = 'G';
                                    colour_req = 'G';
                                    break;
                                default: //other lockout level, just ignore
                                    break;
                            }
                            break;
                            
                        case 'Y': //yellow colour change request
                            switch(lockout)
                            {
                                case 'C': //Yellow colour request
                                    updateIND = 1;
                                    lockout = 'Y';
                                    colour_req = 'Y';
                                    break;
                                
                                case 'B': //blue lockout will be overridden
                                    updateIND = 1;
                                    lockout = 'Y';
                                    colour_req = 'Y';
                                    
                                case 'G': //green lockout will be overridden
                                    updateIND = 1;
                                    lockout = 'Y';
                                    colour_req = 'Y';
                                    break;
                                    
                                default: //other lockout level, just ignore
                                    break;
                            }
                            break;
                            
                        case 'R': //by default Red overrides all other lockouts.
                            lockout = 'R';
                            colour_req = 'R';
                            updateIND = 1;
                            break;
                            
                        //lockout clear requests go here
                        case 'C':
                            switch(buffer[2])
                            {
                                case 'B': //clear blue lockout, clear and confirm by sending 'c' in response
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
                                    
                                case 'Y': //clear yellow lockout, clear and confirm by sending 'c' in response
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
                                    
                                case 'G': //clear green lockout, clear and confirm by sending 'c' in response
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

void vRetransmitTimerFunc( TimerHandle_t xTimer )
{
    GLOBAL_RetransmissionTimerSet = 1;
}