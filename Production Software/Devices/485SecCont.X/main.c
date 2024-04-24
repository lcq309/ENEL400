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

//define global variables
static uint8_t GLOBAL_DeviceID = 0;
static uint8_t GLOBAL_Channel = 0;
static uint8_t GLOBAL_DeviceType = 0;

#define mainWIREDINIT_TASK_PRIORITY (tskIDLE_PRIORITY + 4)
#define mainCOMMOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 3)
#define mainCOMMIN_TASK_PRIORITY (tskIDLE_PRIORITY + 4)
#define mainPBIN_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainINDOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainWSC_TASK_PRIORITY (tskIDLE_PRIORITY + 1)

//task pointers

static void prvWiredInitTask( void * parameters );
static void prvWSCTask( void * parameters );


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

static void prvWiredInitTask( void * parameters )
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
    //ensure that the EventInit is clear
    xSemaphoreTake(xEventInit, 0);
    
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
                //load output buffer
                xStreamBufferSend(xCOMM_out_Stream, PingResponse, 4, portMAX_DELAY);
                //enable transmitter
                
            }
        }
    }
}
