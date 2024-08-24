/* 
 * Menu
 * Author:  Michael King
 * 
 * Created on August 14, 2024
 * 
 * This is the menu controller, it's primary purpose is to take error messages from the 
 * network and pass them on to the HMI display.
 * 
 */

#include <stdio.h>
#include <stdlib.h>
#include <DSIO.h>
#include <MENUTASKS.h>
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

#define ErrLength 10
#define ErrTableLength 50

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

struct ErrorTracker
{
    uint8_t active; //show the state of this error box
    uint8_t state; //show the state of the clear button
    uint8_t message[ErrLength]; //hold the error message to be displayed
};

//define global variables
uint8_t GLOBAL_DeviceID = 0;
uint8_t GLOBAL_Channel = 0;
uint8_t GLOBAL_DeviceType = 'M'; //Menu controller device

#define mainWIREDINIT_TASK_PRIORITY (tskIDLE_PRIORITY + 1)
#define mainCOMMOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 4)
#define mainCOMMIN_TASK_PRIORITY (tskIDLE_PRIORITY + 3)
#define mainPBIN_TASK_PRIORITY (tskIDLE_PRIORITY + 4)
#define mainINDOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainMENU_TASK_PRIORITY (tskIDLE_PRIORITY + 1)

#define MaxNets 40

//global variable
uint8_t errorNum = 0; //track the number of errors

//Error table
struct ErrorTracker ErrorTable[ErrTableLength];

//task pointers

void prvWiredInitTask( void * parameters );
void prvMENUTask( void * parameters );

//retransmission timer

TimerHandle_t xRetransmitTimer;

//timer callback functions

void vRetransmitTimerFunc( TimerHandle_t xTimer );

//timer global

uint8_t GLOBAL_RetransmissionTimerSet = 1; //without setting this, it will never transmit

//Nextion helper functions
void text(uint8_t *output, uint8_t textbox, uint8_t *text);
void numval(uint8_t *output, uint8_t numbox, uint8_t number);
void ButtEn(uint8_t *output, uint8_t numButt);

int main(int argc, char** argv) 
{
    //setup tasks
    xTaskCreate(prvWiredInitTask, "INIT", 300, NULL, mainWIREDINIT_TASK_PRIORITY, NULL);
    xTaskCreate(prvMENUTask, "WLC", 700, NULL, mainMENU_TASK_PRIORITY, NULL);
    
    //setup timer
    
    xRetransmitTimer = xTimerCreate("ReTX", 250, pdFALSE, 0, vRetransmitTimerFunc);
    
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
    uint8_t PingResponse[4] = {0x7e, 0x02, 'R', 'M'};
    
    //wait and listen for the correct ping
    uint8_t byte_buffer[1];
    uint8_t buffer[2];
    uint8_t received = 0;
    uint8_t length = 0;
    while(received != 1)
    {
        //wait for start delimiter
        if(xStreamBufferReceive(xCOMM_in_Stream, byte_buffer, 1, portMAX_DELAY) != 0)
        {
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
                if(buffer[1] == 'M') //if pinging me, wakeup and respond
                {
                    xStreamBufferSend(xCOMM_out_Stream, PingResponse, 4, portMAX_DELAY);
                    USART0.CTRLA |= USART_TXCIE_bm;
                    USART0.CTRLA |= USART_DREIE_bm;
                    USART1.CTRLA |= USART_TXCIE_bm;
                    //set initialization flag
                    xEventGroupSetBits(xEventInit, 0x1);
                    //go to sleep until restart
                    vTaskSuspend(NULL);
                }
            }
        }
    }
}

void prvMENUTask( void * parameters )
{
    /* Wired Sector Controller
     * Maintain a table of all devices.
     */
    struct DeviceTracker ControllerTable[20]; //maximum of 20 connected controlled devices (probably not a hard limit)
    uint8_t numControllers = 0;
    uint8_t tablePos = 0;
    uint8_t numWireless = 0;
    uint8_t numWired = 0;
    struct DeviceTracker DisplayTable[20]; //20 connected lights
    uint8_t numDisplays = 0;
    struct DeviceTracker LightTable[20]; //20 connected lights
    uint8_t numLights = 0;
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
    uint8_t displayWindow = 0; //which window is currently being displayed
    uint8_t NumErrors = 0; //how many errors are there currently
    uint8_t ErrorBox[8] = {'e',0,'.','t','x','t','=','"'}; //textbox to send text change messages
    uint8_t SysBox[9] = {'s','y','s','.','t','x','t','=','"'}; //textbox to send stop button messages
    uint8_t Vis[8] = {'v','i','s',' ', 'b', 0, ',', '1'}; //command to update visibility for buttons
    uint8_t numUpdate[7] = {'n',0,'.','v','a','l','='}; //commands to update numbers
    /* High level overview
     * 1. check for any commands from pushbutton or other internal source.
     * 2. check for any waiting messages.
     * 3. check timer for resending messages if applicable.
     * 4. resend messages if applicable
     * 5. set display
     * 
     * since this is the lowest priority task, it shouldn't need to block for anything on the input side.
     */
    while(1)
    {
        xQueueReceive(xDeviceIN_Queue, buffer, portMAX_DELAY);
        if(buffer[0] == 'P')
            if(buffer[1] == 'P')
                if(buffer[2] == 'S')
                    break;
    }
    //now wait for initialization
    xEventGroupWaitBits(xEventInit, 0x1, pdFALSE, pdFALSE, portMAX_DELAY); //wait for init
    //now that the wired network has initialized, we can start the display
    //start the display by sending page 1
    uint8_t start[6] = {'p','a','g','e',' ','1'};
    xMessageBufferSend(xIND_Buffer, start, 6, 0); //send the start command
    while(1) //wait for the display to confirm it has reached the next page
    {
        xQueueReceive(xDeviceIN_Queue, buffer, portMAX_DELAY);
        if(buffer[0] == 'P')
            if(buffer[1] == 'P')
                if(buffer[2] == 'H')
                    break;
    }
    //we need to send the correct window number now, which should be 1
    numUpdate[1] = '2'; //2 is the window number
    for(int8_t i = 0; i < 7; i++) //load buffer with command
    {
        buffer[i] = numUpdate[i];
    }
    //load buffer with the page number
    buffer[7] = '1';
    //send the command
    xMessageBufferSend(xIND_Buffer, buffer, 8, 0);
    //display should now be initialized properly.
    for(;;)
    {
        xSemaphoreTake(xNotify, 200); //wait for a message to come in from anywhere
        //internal source commands processing
        while(xQueueReceive(xDeviceIN_Queue, buffer, 0) == pdTRUE)
        {
            //check message source
            switch(buffer[0])
            {
                case 'P': // Ptouchscreen (the P is silent)
                    switch(buffer[1])
                    {
                        case 'P': //what page is currently displayed
                            switch(buffer[2])
                            {
                                case 'S': //start page (this will be moved to before the looping section)
                                    xMessageBufferSend(xIND_Buffer, start, 6, 0); //send the start command
                                    break;
                                case 'H': //home page this says that the page is currently the home page (this will also be moved to before the looping section)
                                    break;
                            }
                            break;
                        case 'W': //window change from display
                            displayWindow = buffer[2]; //set current window
                            updateIND = 'W'; //update the display to match the current window
                            break;
                            
                        case 'C': //clear error
                            ErrorTable[((displayWindow - 1) * 5) + (buffer[2] - 1)].active = 0; //this equation is meant to determine which error in the array it is
                            updateIND = 'C'; //rearrange the errors around the one that was just cleared and decrement the count.
                            //the indication update code needs to loop and check all errors and clear up the gap
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
        if(updateIND == 0) //skip the message 
            length = xMessageBufferReceive(xDevice_Buffer, buffer, MAX_MESSAGE_SIZE, 0);
        if(length != 0) //if there is a message in the buffer
        {
            uint8_t router = 0; //byte used for routing from different sources
            //check device type in table and route to correct handling, this section is all just device checks
            switch(GLOBAL_DEVICE_TABLE[buffer[0]].Type)
            {
                case '1':
                case '2':
                    router = 'S'; //S for sector controller
                    break;
                    
                case '3':
                case '4':
                    router = 's'; //s for sector light
                    break;
                    
                case '5':
                    router = 'P'; //P for pit controller
                    break;
                    
                case '6':
                    router = 'p'; //p for pit light
                    break;
                    
                case 'L': //wired lap controller
                    router = 'L'; //L for lap control device
                    break;
                    
                case 'l': //wired lap count display
                    router = 'l'; //l for lap display device
                    break;
                    
                case 'S': //stop button
                    router = 'E'; //emergency stop button
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
                case 'S': //sector controller
                    //add matching code here
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
                        if(GLOBAL_DEVICE_TABLE[ControllerTable[numControllers].index].Type == '1')
                            numWired++;
                        else
                            numWireless++;
                        numControllers++;
                        updateIND = 1;
                    }
                    //add error code here
                    //the only error here would be low battery
                    switch(buffer[1])
                    {
                        case 'E': //error
                            if(buffer[2] == 'L') //low battery
                                if(buffer[3] == 'B')
                                {
                                    //set up the first available error
                                    ErrorTable[NumErrors].message[0] = 'C'; //C for controller
                                    ErrorTable[NumErrors].message[1] = GLOBAL_DEVICE_TABLE[ControllerTable[numControllers].index].Channel + 0x30; //channel number/letter
                                    ErrorTable[NumErrors].message[2] = 'L';
                                    ErrorTable[NumErrors].message[3] = 'B';
                                    updateIND = 'E'; //reshuffle for new error, this will increment error count when processed and move the last error to the front of the list
                                    //send confirmation
                                    buffer[0] = 'e'; //confirm error
                                    buffer[1] = ControllerTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                }
                            break;
                    }
                    break;
                    
                case 's': //sector light
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
                        if(GLOBAL_DEVICE_TABLE[LightTable[numLights].index].Type == '3')
                            numWired++;
                        else
                            numWireless++;
                        numLights++;
                        updateIND = 1;
                    }
                    //this error could be low battery or circuit failure
                    switch(buffer[1])
                    {
                        case 'E': //error
                            switch(buffer[2])
                            {
                                case 'L': //low battery
                                    if(buffer[3] == 'B')
                                    {
                                        //set up the first available error
                                        ErrorTable[NumErrors].message[0] = 'L'; //L for light
                                        ErrorTable[NumErrors].message[1] = GLOBAL_DEVICE_TABLE[ControllerTable[numControllers].index].Channel + 0x30; //channel number/letter
                                        ErrorTable[NumErrors].message[2] = 'L'; //Low
                                        ErrorTable[NumErrors].message[3] = 'B'; //Battery
                                        updateIND = 'E'; //reshuffle for new error, this will increment error count when processed and move the last error to the front of the list
                                        //send confirmation
                                        buffer[0] = 'e'; //confirm error
                                        buffer[1] = LightTable[tablePos].index;
                                        xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                    }
                                    break;
                                    
                                case 'R': //red light failure
                                    //set up the first available error
                                    ErrorTable[NumErrors].message[0] = 'L'; //L for light
                                    ErrorTable[NumErrors].message[1] = GLOBAL_DEVICE_TABLE[ControllerTable[numControllers].index].Channel + 0x30; //channel number/letter
                                    ErrorTable[NumErrors].message[2] = 'R'; //Red
                                    ErrorTable[NumErrors].message[3] = 'L'; //Light
                                    updateIND = 'E'; //reshuffle for new error, this will increment error count when processed and move the last error to the front of the list
                                    //send confirmation
                                    buffer[0] = 'e'; //confirm error
                                    buffer[1] = LightTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                    break;
                                    
                                case 'Y': //yellow light failure
                                    //set up the first available error
                                    ErrorTable[NumErrors].message[0] = 'L'; //L for light
                                    ErrorTable[NumErrors].message[1] = GLOBAL_DEVICE_TABLE[ControllerTable[numControllers].index].Channel + 0x30; //channel number/letter
                                    ErrorTable[NumErrors].message[2] = 'Y'; //Yellow
                                    ErrorTable[NumErrors].message[3] = 'L'; //Light
                                    updateIND = 'E'; //reshuffle for new error, this will increment error count when processed and move the last error to the front of the list
                                    //send confirmation
                                    buffer[0] = 'e'; //confirm error
                                    buffer[1] = LightTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                    break;
                                    
                                case 'G': //green light failure
                                    //set up the first available error
                                    ErrorTable[NumErrors].message[0] = 'L'; //L for light
                                    ErrorTable[NumErrors].message[1] = GLOBAL_DEVICE_TABLE[ControllerTable[numControllers].index].Channel + 0x30; //channel number/letter
                                    ErrorTable[NumErrors].message[2] = 'G'; //Green
                                    ErrorTable[NumErrors].message[3] = 'L'; //Light
                                    updateIND = 'E'; //reshuffle for new error, this will increment error count when processed and move the last error to the front of the list
                                    //send confirmation
                                    buffer[0] = 'e'; //confirm error
                                    buffer[1] = LightTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                    break;
                                    
                                case 'B': //blue light failure
                                    //set up the first available error
                                    ErrorTable[NumErrors].message[0] = 'L'; //L for light
                                    ErrorTable[NumErrors].message[1] = GLOBAL_DEVICE_TABLE[ControllerTable[numControllers].index].Channel + 0x30; //channel number/letter
                                    ErrorTable[NumErrors].message[2] = 'B'; //Blue
                                    ErrorTable[NumErrors].message[3] = 'L'; //Light
                                    updateIND = 'E'; //reshuffle for new error, this will increment error count when processed and move the last error to the front of the list
                                    //send confirmation
                                    buffer[0] = 'e'; //confirm error
                                    buffer[1] = LightTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                    break;
                            }
                    }
                    break;
                    
                case 'P': //pit controller
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
                        numWired++;
                        numControllers++;
                        updateIND = 1;
                    }
                    break;
                    //no errors for this one, this is just in case one is implemented in the future
                    
                case 'p': //pit light
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
                        numWired++;
                        numLights++;
                        updateIND = 1;
                    }
                    //this one might have a circuit failure error
                    switch(buffer[1])
                    {
                        case 'E': //error
                            switch(buffer[2])
                            {
                                case 'R': //red light failure
                                    //set up the first available error
                                    ErrorTable[NumErrors].message[0] = 'P'; //P for pit light
                                    ErrorTable[NumErrors].message[1] = GLOBAL_DEVICE_TABLE[ControllerTable[numControllers].index].Channel + 0x30; //channel number/letter
                                    ErrorTable[NumErrors].message[2] = 'R'; //Red
                                    ErrorTable[NumErrors].message[3] = 'L'; //Light
                                    updateIND = 'E'; //reshuffle for new error, this will increment error count when processed and move the last error to the front of the list
                                    //send confirmation
                                    buffer[0] = 'e'; //confirm error
                                    buffer[1] = LightTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                    break;
                                    
                                case 'Y': //yellow light failure
                                    //set up the first available error
                                    ErrorTable[NumErrors].message[0] = 'P'; //P for pit light
                                    ErrorTable[NumErrors].message[1] = GLOBAL_DEVICE_TABLE[ControllerTable[numControllers].index].Channel + 0x30; //channel number/letter
                                    ErrorTable[NumErrors].message[2] = 'Y'; //Yellow
                                    ErrorTable[NumErrors].message[3] = 'L'; //Light
                                    updateIND = 'E'; //reshuffle for new error, this will increment error count when processed and move the last error to the front of the list
                                    //send confirmation
                                    buffer[0] = 'e'; //confirm error
                                    buffer[1] = LightTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                    break;
                                    
                                case 'G': //green light failure
                                    //set up the first available error
                                    ErrorTable[NumErrors].message[0] = 'P'; //P for pit light
                                    ErrorTable[NumErrors].message[1] = GLOBAL_DEVICE_TABLE[ControllerTable[numControllers].index].Channel + 0x30; //channel number/letter
                                    ErrorTable[NumErrors].message[2] = 'G'; //Green
                                    ErrorTable[NumErrors].message[3] = 'L'; //Light
                                    updateIND = 'E'; //reshuffle for new error, this will increment error count when processed and move the last error to the front of the list
                                    //send confirmation
                                    buffer[0] = 'e'; //confirm error
                                    buffer[1] = LightTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                    break;
                                    
                                case 'B': //blue light failure
                                    //set up the first available error
                                    ErrorTable[NumErrors].message[0] = 'P'; //P for pit light
                                    ErrorTable[NumErrors].message[1] = GLOBAL_DEVICE_TABLE[ControllerTable[numControllers].index].Channel + 0x30; //channel number/letter
                                    ErrorTable[NumErrors].message[2] = 'B'; //Blue
                                    ErrorTable[NumErrors].message[3] = 'L'; //Light
                                    updateIND = 'E'; //reshuffle for new error, this will increment error count when processed and move the last error to the front of the list
                                    //send confirmation
                                    buffer[0] = 'e'; //confirm error
                                    buffer[1] = LightTable[tablePos].index;
                                    xMessageBufferSend(xCOMM_out_Buffer, buffer, 2, 5);
                                    break;
                            }
                    }
                    break;
                    
                case 'L': //lap controller
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
                        numWired++;
                        numControllers++;
                        updateIND = 1;
                    }
                    break;
                    //no errors for the lap controller
                    
                case 'l': //lap display
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
                        numWired++;
                        numLights++;
                    }
                    break;
                    //no errors for the lap display
                    
                case 'E': //emergency stop
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
                        numWired++;
                        numSpecials++;
                        updateIND = 1;
                    }
                    break;
                    //this may be where the system stop message is received if implemented
                    
                case 'M': //menu
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
                        numWired++;
                        numMenus++;
                        updateIND = 1;
                    }
                    break;
                    //so far, there isn't much reason for menus to communicate
            }
        }
        uint8_t check_variable = 1;
    }
    if(updateIND != 0)
    {
        switch(updateIND)
        {
            case 'W': //window update
                //first, update the window number in the buffer
                numval(buffer, 2, displayWindow);
                //send the buffer to the output buffer
                xMessageBufferSend(xIND_Buffer, buffer, 25, 5);
                //display should now be drawn with all errors and the window number updated.
                break;

            case 'C': //error cleared
                //check and see which one was cleared (should be first non-active in table)
                ;
                uint8_t Shufflemode = 0;
                for(uint8_t i = 0; i < ErrTableLength; i++)
                {
                    if(Shufflemode = 0)
                    {
                        if(ErrorTable[i].active != 1) //this is the error that was cleared
                        {
                            //now check if there are any errors after it
                            if(ErrorTable[i + 1].active != 1) //if nothing comes after, then just break the loop
                                i = ErrTableLength;
                            else //change the loop to shuffle the remaining errors
                            {
                                Shufflemode = 1;
                                for(uint8_t y = 0; y < ErrLength; y++)
                                {
                                    ErrorTable[i].message[y] = ErrorTable[i + 1].message[y]; //move first over
                                    ErrorTable[i].active = 1; //this error is now active
                                }
                            }
                        }
                    }
                    else
                    {
                        if(ErrorTable[i].active != 1) //the last error is last in the list
                        {
                            ErrorTable[i - 1].active = 0; //remove the last error in the list
                        }
                        else //shuffle error down by one
                        {
                            for(uint8_t y = 0; y < ErrLength; y++)
                                {
                                    ErrorTable[i].message[y] = ErrorTable[i + 1].message[y]; //shuffle error message
                                }
                        }
                    }
                }
                NumErrors--;
                break;

            case 'E': //error added
                ;
                uint8_t temp[ErrLength];
                for(uint8_t i = 0; i < ErrLength; i++)
                    temp[i] = 0;
                //move the last error to a temporary storage buffer
                for(uint8_t i = 0; i < ErrLength; i++)
                {
                    temp[i] = ErrorTable[NumErrors].message[i];
                }
                //now compare all errors to the new one and see if it exists
                uint8_t matchErr = 0;
                for(uint8_t i = 0; i < ErrTableLength; i++)
                {
                    if(ErrorTable[i].active != 0) //if there is an error here
                    {
                        //compare
                        for(uint8_t y = 0; y < ErrLength; y++)
                        {
                           if(ErrorTable[i].message[y] != temp[y]) //if not matching, end loop and continue
                           {
                               y = ErrLength;
                               matchErr = 0;
                           }
                           else //if matching, keep checking
                           {
                               matchErr = 1;
                           }
                        }
                        if(matchErr == 1) //if the error is already present
                        {
                            i = ErrTableLength;
                        }
                    }
                    else //end execution, we reached an available spot.
                        i = ErrTableLength;
                }
                if(matchErr == 1) //already exists, break execution and ignore
                {
                    break;
                }
                else //it doesn't already exist, shuffle errors and add at the start
                {
                    ErrorTable[NumErrors].active = 1; //set the last error active
                    //shuffle first, start at the back and work towards the front
                    for(int8_t i = NumErrors; i > 0; i--)
                    {
                        for(uint8_t y = 0; y < ErrLength; y++)
                        {
                            ErrorTable[i].message[y] = ErrorTable[i-1].message[y];
                        }
                    }
                    //at this point, all errors should be moved up by one
                    //add the new error at the start
                    for(uint8_t i = 0; i < ErrLength; i++)
                    {
                        ErrorTable[0].message[i] = temp[i];
                    }
                    NumErrors++; //increment error count
                }
                break;
        }

        //then determine what error should be displayed first to redraw the display
        uint8_t firstError = ((displayWindow - 1) * 5);
        uint8_t localErr = 1; //which position should it be displayed in?
        for(uint8_t i = firstError; i < (displayWindow * 5); i++)
        {
            if(ErrorTable[i].active == 1) //if this error is present
            {
                //add the error to the display at the correct point
                text(buffer, localErr, ErrorTable[i].message);
                xMessageBufferSend(xIND_Buffer, buffer, 25, 5);
                //activate the button
                ButtEn(buffer, localErr);
                xMessageBufferSend(xIND_Buffer, buffer, 25, 5);
                localErr++;
            }
            else //no more errors to show, break the loop
                break;
        }
        //then the common updates such as device numbers and system stop

        //device numbers overwrite
        //wireless first
        numval(buffer, 0, numWireless);
        xMessageBufferSend(xIND_Buffer, buffer, 25, 5);
        //wired second
        numval(buffer, 1, numWired);
        xMessageBufferSend(xIND_Buffer, buffer, 25, 5);
        //system stop
        updateIND = 0;
    }
        //loop and restart
} 

//helper functions for Nextion commands
void text(uint8_t *output, uint8_t textbox, uint8_t *text)
{
    uint8_t ErrorBox[8] = {'e',0,'.','t','x','t','=','"'}; //textbox to send text change messages
    uint8_t SysBox[9] = {'s','y','s','.','t','x','t','=','"'}; //textbox to send stop button messages
    if(textbox == 'S') //system stop textbox
    {
        for(uint8_t i = 0; i < 9; i++) //copy command into output buffer
        {
            output[i] = SysBox[i];
        }
        for(uint8_t i = 0; i < 10; i++)
        {
            if(text[i] != 0) //assuming the string is null terminated, anything but 0 should be added
            {
                output[i + 9] = text[i];
            }
            else //the string has ended, add the end quotation mark and break the loop
            {
                output[i + 9] = '"';
                break;
            }
        }
    }
    else
    {
        switch(textbox)
        {
            case 1:
                ErrorBox[1] = '1';
                break;
            case 2:
                ErrorBox[1] = '2';
                break;
            case 3:
                ErrorBox[1] = '3';
                break;
            case 4:
                ErrorBox[1] = '4';
                break;
            case 5:
                ErrorBox[1] = '5';
                break;
        }
        for(uint8_t i = 0; i < 8; i++) //copy command into output buffer
        {
            output[i] = ErrorBox[i];
        }
        for(uint8_t i = 0; i < 10; i++)
        {
            if(text[i] != 0) //assuming the string is null terminated, anything but 0 should be added
            {
                output[i + 8] = text[i];
            }
            else //the string has ended, add the end quotation mark and break the loop
            {
                output[i + 8] = '"';
                break;
            }
        }
    }
}

void numval(uint8_t *output, uint8_t numbox, uint8_t number)
{
    uint8_t numUpdate[7] = {'n',0,'.','v','a','l','='}; //commands to update numbers
    switch(numbox)
    {
        case 0:
            numUpdate[1] = '0';
            break;
            
        case 1:
            numUpdate[1] = '1';
            break;
            
        case 2:
            numUpdate[2] = '2';
            break;
    }
    for(uint8_t i = 0; i < 7; i++) //copy command into output buffer
    {
        output[i] = numUpdate[i];
    }
    //convert the integer to ascii characters (only works up to 99)
    output[7] = (number / 10) + 0x30;
    output[8] = (number % 10) + 0x30; //should result in an ascii 0 through 9.
    //add end quotation mark
    output[9] = '"';
}
void ButtEn(uint8_t *output, uint8_t numButt)
{
    uint8_t Vis[8] = {'v','i','s',' ', 'b', 0, ',', '1'}; //command to update visibility for buttons
    Vis[5] = numButt + 0x30;
    for(uint8_t i = 0; i < 8; i++) //copy over command
    {
        output[i] = Vis[i];
    }
}
void vRetransmitTimerFunc( TimerHandle_t xTimer )
{
    GLOBAL_RetransmissionTimerSet = 1;
}