/* 
 * XBEE Sector Light
 * Author:  Michael King
 * 
 * Created on July 7, 2024
 * 
 * This is meant to be a generic Sector Light on the wireless network
 * which means that it drives a light with either 3 or 4 colours
 * there is a physical way to check which one this is.
 */

#include <stdio.h>
#include <stdlib.h>
#include <DSIO.h>
#include <XBEETASKS.h>
#include "USART.h"
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/delay.h>
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
    uint8_t status;
};

//define global variables
uint8_t GLOBAL_DeviceID = 0;
uint8_t GLOBAL_Channel = 0;
uint8_t GLOBAL_DeviceType = '4'; //Generic Sector Light: Wireless Light
uint8_t GLOBAL_ColourNum = 0; //3 or 4 colour light

#define mainWIRELESSINIT_TASK_PRIORITY (tskIDLE_PRIORITY + 4)
#define mainCOMMOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 3)
#define mainCOMMIN_TASK_PRIORITY (tskIDLE_PRIORITY + 4)
#define mainPBIN_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainINDOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainXSL_TASK_PRIORITY (tskIDLE_PRIORITY + 1)


#define MaxNets 50

//retransmission timer

TimerHandle_t xRetransmitTimer;

//timer callback functions

void vRetransmitTimerFunc( TimerHandle_t xTimer );

//timer global

uint8_t GLOBAL_RetransmissionTimerSet = 1; //without setting this, it will never transmit

//task pointers

void prvWirelessInitTask( void * parameters );
void prvXSLTask( void * parameters );

int main(int argc, char** argv) {
    
    //setup tasks
    
    xTaskCreate(prvWirelessInitTask, "INIT", 300, NULL, mainWIRELESSINIT_TASK_PRIORITY, NULL);
    xTaskCreate(prvXSLTask, "WSL", 600, NULL, mainXSL_TASK_PRIORITY, NULL);
    
    //setup timer
    
    xRetransmitTimer = xTimerCreate("ReTX", 250, pdFALSE, 0, vRetransmitTimerFunc);
    
    //grab the channel and device ID
    
    InitShiftIn(); //initialize shift register pins
    LTCHIn(); //latch input register
    GLOBAL_Channel = ShiftIn(); //grab channel
    
    //setup 3 vs 4 colour
    
    //configure PD6 as a pullup input and check if it is high or low.
    //if PD6 is low, then this is a 3 colour light, otherwise it is 4 colour
    
    PORTD.DIRCLR = PIN6_bm; //pin D6 is an input
    PORTD.PIN6CTRL = PORT_PULLUPEN_bm; //enable pullup
    _delay_us(50); //a short delay to ensure that everything is setup properly
    if(PIN6_bm == (PORTD.IN & PIN6_bm)) //if the input is high then 4 colour
        GLOBAL_ColourNum = 4;
    else   //if the input is not high, then it is a 3 colour
        GLOBAL_ColourNum = 3;
    //cleanup by disabling the pullup and the input
    PORTD.PIN6CTRL = PORT_ISC_INPUT_DISABLE_gc; //should overwrite the pullup as well?
    
    
    //setup modules
    
    COMMSetup();
    DSIOSetup();
    
    //set TXCIE to enable transmission end interrupts
    USART0.CTRLA |= USART_TXCIE_bm;
    //done with pre-scheduler initialization, start scheduler
    vTaskStartScheduler();
    return (EXIT_SUCCESS);
}

void prvWirelessInitTask( void * parameters )
{
    /* Wireless Init - Runs Once
     * 1. flash all indicators
     * 2. flash for a few seconds
     * 3. stop blinking lights
     * 4. set the init event group
     * 5. suspend permanently
     */
    //start flashing indicators
    uint8_t FlashAll[2] = {'Y', 'F'};
    xQueueSendToBack(xIND_Queue, FlashAll, portMAX_DELAY);
    vTaskDelay(6000);
    FlashAll[0] = 0xff; //all but status
    FlashAll[1] = 'O'; //Off
    xQueueSendToBack(xIND_Queue, FlashAll, portMAX_DELAY);
    //set initialization flag
    xEventGroupSetBits(xEventInit, 0x1);
    vTaskSuspend(NULL);
}

void prvXSLTask( void * parameters )
{
    /* Wireless Sector light
     * maintain a table of controller indexes to easily send replies and send error messages
     * reply confirmation when a controller tries to set colour, and send a message if an error is detected
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
    uint8_t colour_req = 'O'; //requested colour
    uint8_t colour_cur = 'O'; //current confirmed colour
    uint8_t Colour_Change_Sample_Block = 1; //block the first sample after a colour change.
    uint8_t Error_send = 0; //errors to be sent will be here, to be handled at the end of the loop.
    uint8_t lowbatt = 0; //used for tracking low battery state
    
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
        xSemaphoreTake(xNotify, 200);
        //internal source commands processing
        if(xQueueReceive(xDeviceIN_Queue, buffer, 0) == pdTRUE)
        {
            //check message source (light check message will come here)
            switch(buffer[0])
            {
                case 'T': //timers
                {
                    switch(buffer[1])
                    {
                        case 'J': //network join
                            //send the network join message
                            ; //this needs to be here or an error is thrown for the next line.
                            uint8_t NetJoin[1] = {0xff};
                            xMessageBufferSend(xCOMM_out_Buffer, NetJoin, 1, 0);
                            xMessageBufferSend(xCOMM_out_Buffer, NetJoin, 1, 0);
                            xMessageBufferSend(xCOMM_out_Buffer, NetJoin, 1, 0);
                            break;
                    }
                }
                break;
                
                case 'S': //Status check, low battery will come here for battery powered lights, otherwise it is just the circuit check
                {
                    switch(buffer[1])
                    {
                        case 'B': //low battery
                            lowbatt = 1;
                            break;
                        case 'L': //light error, only act if not in progress of colour change
                            if(Colour_Change_Sample_Block == 0)
                            {
                                //if we are here, then there is an error
                                Error_send = colour_cur;
                            }
                            else
                                Colour_Change_Sample_Block = 0;
                            break;
                    }
                }
                break;
                default:
                    break;
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
                    
                case 'S': //stop button card
                    router = 'S';
                    break;
                    
                case 'M': //menu controller
                    router = 'M';
                    break;
                    
                default: //not programmed device type
                    //could put an error here in the future
                    router = 0;
                    break;
            }
            //confirm if device is present on table
            uint8_t match = 0;
            switch(router)
            {
                case 'C': //controlling device, check if it is on the internal table, add if not
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
                                case 'C': //no lockout, update colour and send a response message
                                    colour_req = 'B';
                                    lockout = 'B';
                                    buffer[1] = ControllerTable[tablePos].index;
                                    buffer[0] = 'b'; //confirmation
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                    break;
                                    
                                case 'B': //Blue lockout, just reply and confirm
                                    buffer[0] = 'b'; //confirmation
                                    buffer[1] = ControllerTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                    break;
                                    
                                default: //if there is a lockout, just ignore the request
                                    break;
                            }
                            break;
                            
                        case 'G': //Green colour change request
                            //if we are requesting blue, green will override it
                            switch(lockout)
                            {
                                case 'C': //no lockout, this is a green request from a controller
                                    //set lockout and colour_req to green, response is handled later
                                    lockout = 'G';
                                    colour_req = 'G';
                                    buffer[1] = ControllerTable[tablePos].index;
                                    buffer[0] = 'g'; //confirmation
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                    break;
                                
                                case 'G': //Green light confirmation
                                    
                                case 'B': //blue lockout will be overridden
                                    lockout = 'G';
                                    colour_req = 'G';
                                    buffer[1] = ControllerTable[tablePos].index;
                                    buffer[0] = 'g'; //confirmation
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                    break;
                                default: //other lockout level, just ignore
                                    break;
                            }
                            break;
                            
                        case 'Y': //yellow colour change request
                            switch(lockout)
                            {
                                case 'C': //Yellow colour request
                                    lockout = 'Y';
                                    colour_req = 'Y';
                                    buffer[1] = ControllerTable[tablePos].index;
                                    buffer[0] = 'y'; //confirmation
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                    break;
                                
                                case 'B': //blue lockout will be overridden
                                    lockout = 'Y';
                                    colour_req = 'Y';
                                    buffer[1] = ControllerTable[tablePos].index;
                                    buffer[0] = 'y'; //confirmation
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                    break;
                                    
                                case 'Y': //yellow lockout will be repeated
                                    
                                case 'G': //green lockout will be overridden
                                    lockout = 'Y';
                                    colour_req = 'Y';
                                    buffer[1] = ControllerTable[tablePos].index;
                                    buffer[0] = 'y'; //confirmation
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                    break;
                                    
                                default: //other lockout level, just ignore
                                    break;
                            }
                            break;
                            
                        case 'R': //by default Red overrides all other lockouts.
                            lockout = 'R';
                            colour_req = 'R';
                            buffer[1] = ControllerTable[tablePos].index;
                            buffer[0] = 'r'; //confirmation
                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
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
                                            lockout = 'C';
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
                                            
                                        case 'G': //Green lockout is in error, Set colour to yellow and confirm lockout release
                                            colour_req = 'Y';
                                            
                                        case 'Y': //clear the yellow lockout and confirm clearance.
                                            lockout = 'C';
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
                                        case 'G': //clear the green lockout and confirm clearance.
                                            lockout = 'C';
                                            buffer[0] = 'c';
                                            buffer[1] = ControllerTable[tablePos].index;
                                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                            break;
                                            
                                        default: //just ignore anything else for now
                                            break;
                                    }
                                    break;
                                    //red clearance not handled by this type of device.
                                default:
                                    break;
                            }
                            break;
                            
                        default: //can put an error message here, for incorrect command.
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
                            buffer[0] = 'r'; //confirm red
                            buffer[1] = SpecialTable[tablePos].index;
                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                            break;
                            
                        case 'Y': //will send yellow when the stop command has been cleared
                            //overrides any normal colour change logic, will be released by the stop button
                            lockout = 'Y';
                            colour_req = 'Y';
                            buffer[0] = 'y'; //confirm yellow
                            buffer[1] = SpecialTable[tablePos].index;
                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                            break;
                            
                        case 'O': //off command, overrides any normal colour change logic
                            lockout = 'C';
                            colour_req = 'O';
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
                    
                case 'M': //menu
                    //check table and add if needed
                    for(uint8_t i = 0; i < numMenus; i++)
                    {
                        if(MenuTable[i].index == buffer[0])
                        {
                            match = 1;
                            tablePos = i;
                            i = numMenus;
                        }
                    }
                    if(match != 1) //if no match found, add to table
                    {
                        MenuTable[numMenus].index = buffer[0];
                        tablePos = numMenus;
                        numMenus++;
                    }
                    if(length > 1)
                    {
                        switch(buffer[1])
                        {
                            case 'b': //confirm battery
                                MenuTable[tablePos].status = (MenuTable[tablePos].status | 0x1);
                            break;
                            case 'l': //confirm light
                                MenuTable[tablePos].status = (MenuTable[tablePos].status | 0x2);
                            break;   
                        }    
                    }
                    
                    break;
                    
                default: //just do nothing
                    break;
            }
        }
        //message processing now complete, check the status of any colour change request
        //update indicators if needed
        if(colour_cur != colour_req)
        {
            Colour_Change_Sample_Block = 1; //block the first sample
            switch(colour_req)
            {
                case 'B': //blue, flash implied
                    if(GLOBAL_ColourNum == 4)
                    {
                        buffer[0] = 0xff; //all indicators
                        buffer[1] = 'O'; //off
                        xQueueSendToBack(xIND_Queue, buffer, portMAX_DELAY);
                        buffer[0] = 'B'; //blue
                        buffer[1] = 'D'; //double flash
                        xQueueSendToBack(xIND_Queue, buffer, portMAX_DELAY);
                        colour_cur = colour_req;
                    }
                    else //3 colour lights just remain green but report blue
                    {
                        buffer[0] = 0xff; //all indicators
                        buffer[1] = 'O'; //off
                        xQueueSendToBack(xIND_Queue, buffer, portMAX_DELAY);
                        buffer[0] = 'G'; //blue
                        buffer[1] = 'S'; //Solid
                        xQueueSendToBack(xIND_Queue, buffer, portMAX_DELAY);
                        colour_cur = colour_req;
                    }
                    break;
                    
                case 'G': //Green, solid colour
                    buffer[0] = 0xff; //all indicators
                    buffer[1] = 'O'; //off
                    xQueueSendToBack(xIND_Queue, buffer, portMAX_DELAY);
                    buffer[0] = 'G'; //green
                    buffer[1] = 'S'; //Solid
                    xQueueSendToBack(xIND_Queue, buffer, portMAX_DELAY);
                    colour_cur = colour_req;
                    break;
                     
                case 'Y': //Yellow, solid colour
                    buffer[0] = 0xff; //all indicators
                    buffer[1] = 'O'; //off
                    xQueueSendToBack(xIND_Queue, buffer, portMAX_DELAY);
                    buffer[0] = 'Y'; //yellow
                    buffer[1] = 'S'; //Solid
                    xQueueSendToBack(xIND_Queue, buffer, portMAX_DELAY);
                    colour_cur = colour_req;
                    break;
                        
                case 'R': //Red, solid colour
                    buffer[0] = 0xff; //all indicators
                    buffer[1] = 'O'; //off
                    xQueueSendToBack(xIND_Queue, buffer, portMAX_DELAY);
                    buffer[0] = 'R'; //yellow
                    buffer[1] = 'S'; //Solid
                    xQueueSendToBack(xIND_Queue, buffer, portMAX_DELAY);
                    colour_cur = colour_req;
                    break;
                    
                case 'O': //Off
                    buffer[0] = 0xff; //all indicators
                    buffer[1] = 'O'; //off
                    xQueueSendToBack(xIND_Queue, buffer, portMAX_DELAY);
                    colour_cur = colour_req;
                    break;
                        
                default: //something went wrong with a command, just do nothing
                    break;
            }
        }
        uint8_t check_variable = 1;
        uint8_t MessageSent_internal = 0;
        if((lowbatt == 1)  && (GLOBAL_RetransmissionTimerSet == 1) && (GLOBAL_MessageSent == 1))
        {
            //transmit and confirm with all menus
            //ignore the netnumber stuff, there will only ever be one menu per net.
            for(uint8_t i = 0; i < numMenus; i++)
            {
                if((MenuTable[i].status & 0x1) != 0x1)
                {
                    //send another lowbatt message
                    buffer[0] = 'L'; //low
                    buffer[1] = 'B'; //battery
                    buffer[2] = MenuTable[i].index; //load with retransmission request
                    check_variable = 0;
                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 3, 5);
                }
            }
            if(check_variable == 1) //all menus responded and confirmed
            {
                lowbatt = 2; //lowbatt 2 is the confirmation state.
            }
            else
            {
                MessageSent_internal = 1;
            }
        }
        if(MessageSent_internal == 1)
        {
            GLOBAL_MessageSent = 0;
            GLOBAL_RetransmissionTimerSet = 0;
            xTimerReset(xRetransmitTimer, portMAX_DELAY);
        }
        //now check for errors and handle sending the error case.
        if(Error_send != 0)
        {
            uint8_t NetSent[MaxNets];
            for(uint8_t i = 0; i < MaxNets; i++)
            {
                NetSent[i] = 0;
            }
            for(uint8_t i = 0; i < numControllers; i++)
            {
                for(uint8_t y = 0; y < MaxNets; y++)
                {
                    if(NetSent[y] == 0) //if a null is found, end the loop early and send the message
                    {
                        //send the error message
                        buffer[0] = 'E'; //error
                        buffer[1] = Error_send; //error colour
                        buffer[2] = ControllerTable[i].index; //load with retransmission request
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
            Error_send = 0; //don't spam error messages
        }
        //loop and restart
        
    }
}

void vRetransmitTimerFunc( TimerHandle_t xTimer )
{
    GLOBAL_RetransmissionTimerSet = 1;
}