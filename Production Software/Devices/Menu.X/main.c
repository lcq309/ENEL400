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
    uint8_t active; //show the state of this error
    uint8_t state; //show the state of the clear button
    uint8_t message[4]; //hold the error message to be displayed
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

//Error table
struct ErrorTracker ErrorTable[50];

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

void prvMENUTask( void * parameters )
{
    /* Wired Sector Controller
     * Maintain a table of all devices.
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
                            ErrorTable[((displayWindow - 1) * 5) + (buffer[2] - 1)].state = 0; //the button was cleared
                            updateIND = 'C'; //rearrange the errors around the one that was just cleared.
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
                    break;
                    
                case 's': //sector light
                    
                    break;
                    
                case 'P': //pit controller
                    
                    break;
                    
                case 'p': //pit light
                    
                    break;
                    
                case 'L': //lap controller
                    
                    break;
                    
                case 'l': //lap display
                    
                    break;
                    
                case 'M': //menu
                    
                    break;
            }
        }
        //message processing now complete, check the status of any colour change request
        //if all colours are matching colour_req, then change colour_cur into colour_req
        uint8_t check_variable = 1;
    }
    switch(updateIND)
    {
        case 'W': //window update
            break;
            
        case 'C': //error cleared
            break;
            
        case 'E': //error added
            break;
            
            //then the common updates such as device numbers and system stop
            
            //device numbers overwrite
            
            
            //system stop
    }
        //loop and restart
} 

void vRetransmitTimerFunc( TimerHandle_t xTimer )
{
    GLOBAL_RetransmissionTimerSet = 1;
}