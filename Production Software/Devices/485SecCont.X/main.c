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

#define F_CPU 240000000

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

#define mainWIREDINIT_TASK_PRIORITY (tskIDLE_PRIORITY + 4)
#define mainCOMMOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 3)
#define mainCOMMIN_TASK_PRIORITY (tskIDLE_PRIORITY + 4)
#define mainPBIN_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainINDOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainWSC_TASK_PRIORITY (tskIDLE_PRIORITY + 1)

//task pointers

void prvWiredInitTask( void * parameters );
void prvWSCTask( void * parameters );


int main(int argc, char** argv) {
    
    //setup tasks
    xTaskCreate(prvWiredInitTask, "INIT", 300, NULL, mainWIREDINIT_TASK_PRIORITY, NULL);
    xTaskCreate(prvWSCTask, "WSC", 600, NULL, mainWSC_TASK_PRIORITY, NULL);
    COMMSetup();
    DSIOSetup();
    
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
    uint8_t colour_req; //requested colour
    uint8_t colour_cur; //current confirmed colour
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
                    switch(lockout)
                    {
                        case 'C': //clear, allow colour change request
                            colour_req = buffer[1];
                            Requester = 1;
                            break;
                            
                        case 'G': //green lockout, allow yellow through but not blue
                            switch(buffer[1])
                            {
                                case'Y': //yellow light
                                    colour_req = buffer[1];
                                    Requester = 1;
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
                                    lockout = 'G';
                                    colour_req = 'G';
                                    Requester = 2; //start helping with colour change
                                    buffer[0] = 'g';
                                    buffer[1] = ControllerTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                    break;
                                
                                case 'B': //blue lockout will be overridden
                                    ControllerTable[tablePos].status = buffer[1];
                                    lockout = 'G';
                                    colour_req = 'G';
                                    Requester = 2;
                                    buffer[0] = 'g';
                                    buffer[1] = ControllerTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                    
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
                                case 'C': //no lockout, this is a green request from another controller
                                    //set lockout and colour_req to green, update controller status, and reply
                                    ControllerTable[tablePos].status = buffer[1];
                                    lockout = 'G';
                                    colour_req = 'G';
                                    Requester = 2; //start helping with colour change
                                    buffer[0] = 'g';
                                    buffer[1] = ControllerTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                    break;
                                
                                case 'B': //blue lockout will be overridden
                                    ControllerTable[tablePos].status = buffer[1];
                                    lockout = 'Y';
                                    colour_req = 'Y';
                                    Requester = 2;
                                    buffer[0] = 'y';
                                    buffer[1] = ControllerTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                                    
                                case 'G': //green lockout will be overridden
                                    ControllerTable[tablePos].status = buffer[1];
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
                            buffer[0] = 'r'; //confirm red
                            buffer[1] = SpecialTable[tablePos].index;
                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                            break;
                            
                        case 'Y': //will send yellow when the stop command has been cleared
                            //overrides any normal colour change logic, will be released by the stop button
                            lockout = 'Y';
                            colour_req = 'Y';
                            Requester = 2;
                            buffer[0] = 'y'; //confirm yellow
                            buffer[1] = SpecialTable[tablePos].index;
                            xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, portMAX_DELAY);
                            break;
                            
                        case 'O': //off command, overrides any normal colour change logic
                            lockout = 'C';
                            colour_req = 'O';
                            Requester = 2;
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
            if(colour_cur != colour_req)
            {
                //how this acts depends on if it is a requester 1 or 2
                if(Requester == 1)
                {
                    //check lights and other controllers
                }
                else //only check lights
                {
                    
                }
            }
            //check retransmission timers if needed and retransmit
            if(colour_cur != colour_req)
            {
                
            }
            //update indicators if needed
            if(colour_cur != colour_req)
            {
                //set both to flash
            }
            else if(colour_cur == colour_req)
            {
                //set solid
            }
            //loop and restart
        }
    }
    
}