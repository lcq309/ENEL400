/* 
 * RS 485 Sector Controller
 * Author:  Michael King
 * 
 * Created on April 22, 2024
 * 
 * This is meant to be a generic Sector Light controller on the wired network
 * which means that it has 3 buttons (Blue, Yellow, Green) and controls 
 * a sector light with either 3 or 4 colours.
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
uint8_t GLOBAL_DeviceType = '1';

#define mainWIREDINIT_TASK_PRIORITY (tskIDLE_PRIORITY + 1)
#define mainCOMMOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 4)
#define mainCOMMIN_TASK_PRIORITY (tskIDLE_PRIORITY + 3)
#define mainPBIN_TASK_PRIORITY (tskIDLE_PRIORITY + 4)
#define mainINDOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainWSC_TASK_PRIORITY (tskIDLE_PRIORITY + 1)

#define MaxNets 40

//task pointers

void prvWiredInitTask( void * parameters );
void prvWSCTask( void * parameters );

//retransmission timer

TimerHandle_t xRetransmitTimer;

//timer callback functions

void vRetransmitTimerFunc( TimerHandle_t xTimer );

//timer global

uint8_t GLOBAL_RetransmissionTimerSet = 1; //without setting this, it will never transmit

int main(int argc, char** argv) {
    
    //setup tasks
    xTaskCreate(prvWiredInitTask, "INIT", 300, NULL, mainWIREDINIT_TASK_PRIORITY, NULL);
    xTaskCreate(prvWSCTask, "WSC", 700, NULL, mainWSC_TASK_PRIORITY, NULL);
    
    //setup timer
    
    xRetransmitTimer = xTimerCreate("ReTX", 1000, pdFALSE, 0, vRetransmitTimerFunc);
    
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
    uint8_t colour_err = 0; //error tracking colour
    uint8_t Requester = 0; //is this device currently requesting a colour change
    uint8_t ForceCheck = 0; //used to force the device to check on the first go through.
    uint8_t lightbatt = 0;
    
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
        xSemaphoreTake(xNotify, 200); //wait for a message to come in from anywhere
        //internal source commands processing
        uint8_t breakloop = 0; //used to break the loop when yellow lockout is set
        while((xQueueReceive(xDeviceIN_Queue, buffer, 0) == pdTRUE) && (breakloop == 0))
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
                            lockout = buffer[1];
                            Requester = 1; //we are initiating this change
                            ForceCheck = 1;
                            updateIND = 1; //update the indicators
                            GLOBAL_RetransmissionTimerSet = 1; //update indicator checks immediately
                            break;
                        
                        case 'b': //blue lockout clearing
                        case 'B': //blue lockout, allow any colour through
                            switch(buffer[1])
                            {
                                default:
                                    colour_req = buffer[1];
                                    lockout = buffer[1];
                                    colour_cur = 'O'; //reset processing
                                    Requester = 1; //we are initiating this change
                                    ForceCheck = 1;
                                    updateIND = 1; //update the indicators
                                    GLOBAL_RetransmissionTimerSet = 1; //update indicator checks immediately
                                    break;  
                            }
                            break;
                            
                        case 'g': //green lockout clearing
                        case 'G': //green lockout, allow yellow through but not blue
                            switch(buffer[1])
                            {
                                case 'Y': //yellow light
                                    colour_req = buffer[1];
                                    lockout = buffer[1];
                                    colour_cur = 'O'; //reset processing
                                    Requester = 1; //we are initiating this change
                                    ForceCheck = 1;
                                    updateIND = 1; //update the indicators
                                    GLOBAL_RetransmissionTimerSet = 1; //update indicator checks immediately
                                    break;
                                    
                                case 'G': //Green retry
                                case 'B': //blue light
                                    //flash green for a short time
                                    buffer[0] = 0xff;
                                    buffer[1] = 'O'; //turn all off first
                                    xQueueSendToFront(xIND_Queue, buffer, portMAX_DELAY);
                                    buffer[0] = 'G';
                                    buffer[1] = 'W'; //green warn flash
                                    xQueueSendToFront(xIND_Queue, buffer, portMAX_DELAY);
                                    updateIND = 1;
                                    ForceCheck = 1;
                                    GLOBAL_RetransmissionTimerSet = 1; //update indicator checks immediately
                                    break;
                            }
                            break;
                            
                        case 'y': //yellow lockout clearing
                        case 'Y': //yellow lockout, flash yellow for a short time
                            colour_req = 'Y'; //reset processing
                            colour_cur = 'O'; //reset processing
                            lockout = 'Y'; //reset processing
                            buffer[0] = 0xff;
                            buffer[1] = 'O'; //turn all off first
                            xQueueSendToFront(xIND_Queue, buffer, portMAX_DELAY);
                            buffer[0] = 'Y';
                            buffer[1] = 'W'; //yellow warn flash
                            xQueueSendToFront(xIND_Queue, buffer, portMAX_DELAY);
                            updateIND = 1;
                            ForceCheck = 1;
                            GLOBAL_RetransmissionTimerSet = 1; //update indicator checks immediately
                            breakloop = 1; //break the loop so this command can be processed right away.
                            //running code will fix indicators after this delay has passed.
                            break;
                            
                        case 'r': //red lockout clearing
                        case 'R': //red lockout, flash all for a short time
                            buffer[0] = 0xff;
                            buffer[1] = 'O'; //turn all off first
                            xQueueSendToFront(xIND_Queue, buffer, portMAX_DELAY);
                            buffer[0] = 0xff;
                            buffer[1] = 'W'; //warning flash all
                            xQueueSendToFront(xIND_Queue, buffer, portMAX_DELAY);
                            updateIND = 1;
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
                    if(match != 1) //if no match found, add to table and check if the wireless address is matching anything
                    {
                        ControllerTable[numControllers].index = buffer[0];
                        tablePos = numControllers;
                        numControllers++;
                    }
                    //now the device is on the table, evaluate its message (if one is present)
                    if(length > 1)
                    {
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
                                        xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                        break;

                                    case 'B': //Blue lockout
                                        switch(Requester)
                                        {
                                            case 1: //this is a requester one, update status and respond with confirmation
                                                ControllerTable[tablePos].status = buffer[1];
                                                buffer[0] = 'b'; //confirmation
                                                buffer[1] = ControllerTable[tablePos].index;
                                                xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                                break;
                                            case 2: //this is a subordinate requester, just respond with confirmation
                                                buffer[0] = 'b'; //confirmation
                                                buffer[1] = ControllerTable[tablePos].index;
                                                xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                                break;
                                        }
                                        break;

                                    default: //if there is a lockout, respond with the lockout colour and take control
                                        Requester = 1;
                                        updateIND = 1;
                                        buffer[0] = lockout;
                                        buffer[1] = ControllerTable[tablePos].index; //respond with controller lockout colour
                                        //this should set the controller as requester 2 with a lockout
                                        xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
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
                                        xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                        break;

                                    case 'B': //blue lockout will be overridden
                                        ControllerTable[tablePos].status = buffer[1];
                                        updateIND = 1;
                                        lockout = 'G';
                                        colour_req = 'G';
                                        Requester = 2;
                                        buffer[0] = 'g';
                                        buffer[1] = ControllerTable[tablePos].index;
                                        xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                        break;

                                    case 'G': //green lockout
                                        switch(Requester)
                                        {
                                            case 1: //this is a requester one, update status and respond with confirmation
                                                ControllerTable[tablePos].status = buffer[1];
                                                buffer[0] = 'g'; //confirmation
                                                buffer[1] = ControllerTable[tablePos].index;
                                                xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                                break;
                                            case 2: //this is a subordinate requester, just respond with confirmation
                                                buffer[0] = 'g'; //confirmation
                                                buffer[1] = ControllerTable[tablePos].index;
                                                xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                                break;
                                        }
                                        break;
                                    default: //other lockout level, reply with lockout level
                                        buffer[0] = lockout; 
                                        buffer[1] = ControllerTable[tablePos].index;
                                        xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
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
                                        xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                        break;

                                    case 'b': //blue lockout release will be overridden
                                    case 'B': //blue lockout will be overridden
                                        ControllerTable[tablePos].status = buffer[1];
                                        updateIND = 1;
                                        lockout = 'Y';
                                        colour_req = 'Y';
                                        Requester = 2;
                                        buffer[0] = 'y';
                                        buffer[1] = ControllerTable[tablePos].index;
                                        xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                        break;

                                    case 'g': //green lockout release will be overridden
                                    case 'G': //green lockout will be overridden
                                        ControllerTable[tablePos].status = buffer[1];
                                        updateIND = 1;
                                        lockout = 'Y';
                                        colour_req = 'Y';
                                        Requester = 2;
                                        buffer[0] = 'y';
                                        buffer[1] = ControllerTable[tablePos].index;
                                        xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                        break;

                                    case 'y': //yellow lockout release will be overridden
                                    case 'Y': //yellow lockout
                                        switch(Requester)
                                        {
                                            case 1: //this is a requester one, update status and respond with confirmation
                                                ControllerTable[tablePos].status = buffer[1];
                                                buffer[0] = 'y'; //confirmation
                                                buffer[1] = ControllerTable[tablePos].index;
                                                xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                                break;
                                            case 2: //this is a subordinate requester, just respond with confirmation
                                                buffer[0] = 'y'; //confirmation
                                                buffer[1] = ControllerTable[tablePos].index;
                                                xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                                break;
                                        }
                                        break;
                                    default: //other lockout level, reply with lockout level
                                        buffer[0] = lockout; 
                                        buffer[1] = ControllerTable[tablePos].index;
                                        xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
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
                                xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                break;

                            case 'r': //red confirmation, shouldn't end up here normally, just ignore for now
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
                                                xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
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
                                                xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                                break;

                                            case 'b': //we are working on clearing lights, just confirm clearance.
                                                buffer[0] = 'c';
                                                buffer[1] = ControllerTable[tablePos].index;
                                                xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
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
                                                xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
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
                                                xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                                break;

                                            case 'y': //we are working on clearing lights, just confirm clearance.
                                                buffer[0] = 'c';
                                                buffer[1] = ControllerTable[tablePos].index;
                                                xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
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
                                                xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
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
                                                xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                                break;

                                            case 'g': //we are working on clearing lights, just confirm clearance.
                                                buffer[0] = 'c';
                                                buffer[1] = ControllerTable[tablePos].index;
                                                xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
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
                }
                break;
                
                case 'L': //light device, should only ever be confirming colours or giving an error response
                    //just mark status as confirmed
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
                                
                            case 'L': //low battery
                                lightbatt = 1; //start warning about light battery
                                updateIND = 1;
                                buffer[0] = 'b'; //confirm battery
                                buffer[1] = LightTable[tablePos].index;
                                xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                break;
                                
                            default: //anything else should just be state confirmations
                                LightTable[tablePos].status = (buffer[1] - 32); //subtract 32 to get uppercase letter
                                break;
                        }
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
                    if(length > 1)
                    {
                        switch(buffer[1])
                        {
                            case 'R': //red request, we are required to turn red
                                lockout = 'R'; //can only be released by Stop button
                                colour_req = 'R';
                                colour_cur = 'R';
                                Requester = 0;
                                updateIND = 1;
                                buffer[0] = 'r'; //confirm red
                                buffer[1] = SpecialTable[tablePos].index;
                                xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                break;

                            case 'Y': //will send yellow when the stop command has been cleared
                                //overrides any normal colour change logic, will be released by the stop button
                                lockout = 'Y';
                                colour_req = 'Y';
                                Requester = 2;
                                updateIND = 1;
                                buffer[0] = 'y'; //confirm yellow
                                buffer[1] = SpecialTable[tablePos].index;
                                xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                break;

                            case 'O': //off command, overrides any normal colour change logic
                                lockout = 'C';
                                colour_req = 'O';
                                colour_cur = 'O';
                                Requester = 0;
                                updateIND = 1;
                                buffer[0] = 'o'; //confirm off
                                buffer[1] = SpecialTable[tablePos].index;
                                xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                break;

                            case 'C': //Clear command, stop light is special and doesn't need to follow the same rules that a controller would
                                lockout = 'C';
                                colour_cur = colour_req;
                                updateIND = 1;
                                buffer[0] = 'c'; //confirm clear
                                buffer[1] = SpecialTable[tablePos].index;
                                xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
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
            for(int8_t i = 0; i < numControllers; i++)
                ControllerTable[i].status = 0;
            for(int8_t i = 0; i < numLights; i++)
                LightTable[i].status = 0;
            ForceCheck = 0;
        }
        if((colour_cur != colour_req) && (colour_cur != (colour_req + 32))) //this also allows the lowercase through, since it will only be the lowercase form once all devices have confirmed.
        {
            switch(Requester)
            //how this acts depends on if it is a requester 1 or 2
            {
                
                case 1: //Lead Requester
                //check retransmission timers and retransmit if needed
                    if(GLOBAL_RetransmissionTimerSet == 1 && GLOBAL_MessageSent == 1)
                    {
                        //check other controllers
                        for(int8_t i = 0; i < numControllers; i++)
                        {
                            if(ControllerTable[i].status != colour_req)
                            {
                                for(int8_t y = 0; y < MaxNets; y++)
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
                        for(int8_t i = 0; i < numLights; i++)
                        {
                            if(LightTable[i].status != colour_req)
                            {
                                for(int8_t y = 0; y < MaxNets; y++)
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
                            ForceCheck = 1;
                        }
                        //reset transmission timer, might also add a separate check to ensure that a transmission has actually occurred.
                        else // if something was transmitted, we need to reset the timer.
                        {
                            GLOBAL_RetransmissionTimerSet = 0;
                            xTimerReset(xRetransmitTimer, portMAX_DELAY);
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
        if(ForceCheck == 1) //if we are forcing a state check
        {
            for(int8_t i = 0; i < numControllers; i++)
                ControllerTable[i].status = 0;
            for(int8_t i = 0; i < numLights; i++)
                LightTable[i].status = 0;
            ForceCheck = 0;
        }
        switch(Requester)
        {
            case 1:
                if((lockout == colour_cur) && (GLOBAL_RetransmissionTimerSet == 1) && (GLOBAL_MessageSent == 1)) //at this point, all devices have confirmed change and we should start releasing lockouts
                {
                    for(uint8_t i = 0; i < numControllers; i++)
                        {
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
                        ForceCheck = 1;
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
            else if(lockout == colour_cur)
            {
                //set single light flash to show all devices have confirmed change but are still releasing controllers
                buffer[0] = 0xff; //all indicators
                buffer[1] = 'O'; //off
                xQueueSendToBack(xIND_Queue, buffer, portMAX_DELAY);
                buffer[0] = colour_cur;
                buffer[1] = 'F'; //flash
                xQueueSendToBack(xIND_Queue, buffer, portMAX_DELAY);
            }
            else if(lockout == (colour_cur + 32))
            {
                //set single light flash to show all devices have confirmed change but are still releasing lights
                buffer[0] = 0xff; //all indicators
                buffer[1] = 'O'; //off
                xQueueSendToBack(xIND_Queue, buffer, portMAX_DELAY);
                buffer[0] = colour_cur;
                buffer[1] = 'D'; //double flash
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
                if(lightbatt == 1)
                {
                buffer[0] = colour_cur;
                buffer[1] = 'B'; //slow blink
                xQueueSendToBack(xIND_Queue, buffer, portMAX_DELAY);
                }
            }
                //error case should blink lights slowly.
            updateIND = 0;
        }
        //loop and restart
    } 
}

void vRetransmitTimerFunc( TimerHandle_t xTimer )
{
    GLOBAL_RetransmissionTimerSet = 1;
}