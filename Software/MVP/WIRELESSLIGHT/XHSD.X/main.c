/* 
 * File:   main.c - MAR generic
 * Author: Michael King
 * MVP version
 *
 * The purpose of this is to create a minimum viable running code for the Marshal
 * controllers, this code is for the general case.
 * Created on March 26, 2024
 */
/* Version one: Basics only
 * The purpose of this is to provide a testbed for the RS485 network, and networking
 * in general. No optional features are included
 */
#include <stdio.h>
#include <stdlib.h>
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

#define MAX_MESSAGE_SIZE 200 //maximum message size allowable, includes formatting

static uint8_t GLOBAL_Channel = 0x01; //channel number is set during initial startup
static uint8_t GLOBAL_TableLength = 0; //increments as new entries are added to the table

static const uint8_t START[1] = {0x7E};
static const uint8_t FRAME_TYPE[1] = {0x10};
static const uint8_t FRAME_ID[1] = {0x00};
static const uint8_t TARGET_ADDRESS[8] = {0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0};
static const uint8_t Short_Address[2] = {0xff, 0xfe};
static const uint8_t RADIUS[1] = {0x0};
static const uint8_t OPTIONS[1] = {0x0};


// Priority Definitions:

#define mainRS485OUT_TASK_PRIORITY (tskIDLE_PRIORITY + 3)
#define mainRS485IN_TASK_PRIORITY (tskIDLE_PRIORITY + 4)
#define mainPBIN_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainINDOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainWBM_TASK_PRIORITY (tskIDLE_PRIORITY + 1)

// Task pointers

static void prvXBeeOutTask ( void *parameters );
static void prvXBeeInTask ( void *parameters );
static void prvPbInTask ( void *parameters );
static void prvIndOutTask ( void *parameters );
static void prvMARTask ( void *parameters );


//Mutexes

static SemaphoreHandle_t xDeviceBuffer_MUTEX = NULL;

//Semaphores

static SemaphoreHandle_t xPermission = NULL; //task notification replacement
static SemaphoreHandle_t xTXC = NULL;

//event groups

static EventGroupHandle_t xInit = NULL;

//stream handles

static StreamBufferHandle_t xBee_in_Stream = NULL;
static StreamBufferHandle_t xBee_out_Stream = NULL;
static MessageBufferHandle_t xBee_out_Buffer = NULL;
static MessageBufferHandle_t xDevice_Buffer = NULL;

//queue handles

static QueueHandle_t xPB_Queue = NULL;
static QueueHandle_t xIND_Queue = NULL;

//device table


int main(int argc, char** argv) {
    //clock is set by FreeRTOS
    //enable USART0 (XBEE)
    USART0_init();
    //setup buffers and streams
    
    xBee_in_Stream = xStreamBufferCreate(50,1); //50 bytes, triggers when a byte is added
    xBee_out_Stream = xStreamBufferCreate(MAX_MESSAGE_SIZE, 1); //output buffer
    xBee_out_Buffer = xMessageBufferCreate(400);
    xDevice_Buffer = xMessageBufferCreate(200);
    
    //setup Queues
    
    xPB_Queue = xQueueCreate(3, sizeof(uint8_t)); //up to 3 button presses held
    xIND_Queue = xQueueCreate(3, 2 * sizeof(uint8_t)); // up to 3 Indicator Commands held
    
    //setup mutex(es)
    
    xDeviceBuffer_MUTEX = xSemaphoreCreateMutex();
    
    //setup semaphore
    
    xTXC = xSemaphoreCreateBinary();
    
    //setup tasks
    
    xTaskCreate(prvXBeeOutTask, "RSOUT", 500, NULL, mainRS485OUT_TASK_PRIORITY, NULL);
    xTaskCreate(prvXBeeInTask, "RSIN", 400, NULL, mainRS485IN_TASK_PRIORITY, NULL);
    xTaskCreate(prvPbInTask, "PBIN", 250, NULL, mainPBIN_TASK_PRIORITY, NULL);
    xTaskCreate(prvIndOutTask, "INDOUT", 250, NULL, mainINDOUT_TASK_PRIORITY, NULL);
    xTaskCreate(prvMARTask, "MAR", 600, NULL, mainWBM_TASK_PRIORITY, NULL);
    
    //setup device ID and channel here, read shift registers and move into global variables
        //setup device ID and channel here, read shift registers and move into global variables
    InitShiftIn(); //initialize shift register pins
    LTCHIn(); //latch input register
    GLOBAL_Channel = ShiftIn(); //grab channel
    //should now be done with shift registers
    //initialize device table to all 0s? Not needed
    vTaskStartScheduler(); //start scheduler
    return (EXIT_SUCCESS);
}

static void prvXBeeOutTask(void * parameters)
{
    uint8_t XBee_Length[2];
    uint8_t buffer[MAX_MESSAGE_SIZE];
    uint8_t checksum[1];
    int checkcalc = 0;
    for(;;)
    {
    uint8_t size = xMessageBufferReceive(xBee_out_Buffer, buffer, MAX_MESSAGE_SIZE, portMAX_DELAY);
    //prepare message for sending by adding xbee header info to the buffer
    XBee_Length[0] = 0;
    XBee_Length[1] = size + 8 + 2 + 1 + 1 + 1 + 1;
    //add message length
    xStreamBufferSend(xBee_out_Stream, XBee_Length, 2, portMAX_DELAY);
    //add frame type
    xStreamBufferSend(xBee_out_Stream, FRAME_TYPE, 1, portMAX_DELAY);
    //add frame ID
    xStreamBufferSend(xBee_out_Stream, FRAME_ID, 1, portMAX_DELAY);
    //add 8 byte address
    xStreamBufferSend(xBee_out_Stream, TARGET_ADDRESS, 8, portMAX_DELAY);
    //add 2 byte address
    xStreamBufferSend(xBee_out_Stream, Short_Address, 2, portMAX_DELAY);
    //add broadcast radius
    xStreamBufferSend(xBee_out_Stream, RADIUS, 1, portMAX_DELAY);
    //add transmit options
    xStreamBufferSend(xBee_out_Stream, OPTIONS, 1, portMAX_DELAY);
    //add message here
    xStreamBufferSend(xBee_out_Stream, buffer, size, portMAX_DELAY);
    //calculate the checksum
    checkcalc = FRAME_TYPE[0] + FRAME_ID[0] + TARGET_ADDRESS[0] + TARGET_ADDRESS[1] + TARGET_ADDRESS[2] + TARGET_ADDRESS[3] + TARGET_ADDRESS[4] + TARGET_ADDRESS[5] + TARGET_ADDRESS[6] + TARGET_ADDRESS[7] + Short_Address[0] + Short_Address[1];
    checkcalc = checkcalc + RADIUS[0] + OPTIONS[0];
    
    for(int i = 0; i < size; i++)
    {
        checkcalc = checkcalc + buffer[i];
    }
    checksum[0] = checkcalc & 0xff;
    checksum[0] = 0xff - checksum;
    xStreamBufferSend(xBee_out_Stream, checksum, 1, portMAX_DELAY);
    }
    //message now assembled, send it by loading output register and enabling DRE interrupt
    USART0.TXDATAL = START[0];
    //enable DRE interrupt
    USART0.CTRLA |= USART_DREIE_bm;
    //wait for TXcomplete notification
    xSemaphoreTake(xTXC, portMAX_DELAY);
    //end of loop, start over now
}

static void prvXBeeInTask(void * parameters)
{   //there is only one sender, we should be able to basically ignore all header stuff and just send the message byte to the controller task
    uint8_t byte_buffer[1];
    uint8_t buffer[MAX_MESSAGE_SIZE];
    uint8_t length[2];
    xStreamBufferReceive(xBee_in_Stream, byte_buffer, 1, portMAX_DELAY);
    if(byte_buffer[0] == 0x7E) //if not start delimiter, break somehow
    {
        //grab length
        xStreamBufferReceive(xBee_in_Stream, length, 2, portMAX_DELAY);
        //grab message of length
        xStreamBufferReceive(xBee_in_Stream, buffer, length[1], portMAX_DELAY);
        //grab checksum
        xStreamBufferReceive(xBee_in_Stream, byte_buffer, 1, portMAX_DELAY);
        //pass message byte to the device specific task, for a receive packet it should be byte 15
        //grab the mutex
        //grab device buffer MUTEX
        xSemaphoreTake(xDeviceBuffer_MUTEX, portMAX_DELAY);
        //send to device buffer
        xMessageBufferSend(xDevice_Buffer, buffer, 1, portMAX_DELAY);
        //release device MUTEX
        xSemaphoreGive(xDeviceBuffer_MUTEX);
        //now done with message processing
        
    }
}

static void prvPbInTask(void * parameters)
{
    /* Pushbutton In Task
     * Takes input from the pushbutton interrupts, keeps track of last button to
     * provide software debouncing (probably not used so much on the lap count driver)
     * 1. wait for something to come in from the queue (pushbutton interrupts)
     * 2. acquire device specific MUTEX
     * 3. pass to device specific
     */
    uint8_t last = 0; //variable for software debouncing
    //I will setup the interrupts and inputs here
    //I will start by ensuring all pins are inputs
    PORTD.DIRCLR = PIN6_bm | PIN5_bm | PIN4_bm;
    //Then I will set up the multi-configure register for port D.
    PORTD.PINCONFIG = 0x3 | PORT_PULLUPEN_bm; //enable falling edge interrupt and pullup
    //update configuration for selected pins
    PORTD.PINCTRLUPD = PIN6_bm | PIN5_bm | PIN4_bm;
    //now interrupts should be enabled, I will have to implement the routines below
    //initialization complete, enter looping section.
    uint8_t input[1];
    for(;;)
    {
        //wait for something to come in from the queue
        xQueueReceive(xPB_Queue, input, portMAX_DELAY);
        //add a messaging byte to the front, 0x04 in this case
        //device specific needs to check for a two-byte message and react according to the first byte of the message
        if(input[0] != last)
        {
        uint8_t output[2];
        output[0] = 0x04;
        output[1] = input[0];
        //grab device buffer MUTEX
        xSemaphoreTake(xDeviceBuffer_MUTEX, portMAX_DELAY);
        //send to device buffer
        xMessageBufferSend(xDevice_Buffer, output, 2, portMAX_DELAY);
        //release device MUTEX
        xSemaphoreGive(xDeviceBuffer_MUTEX);
        }
    }
}

static void prvIndOutTask(void * parameters)
{
    // first I will initialize the pins as outputs
    PORTD.DIRSET = PIN1_bm | PIN3_bm;
    PORTC.DIRSET = PIN3_bm;
    
    /* Indicator out loop:
     * 1. wait for message on input queue
     * 2. process message
     * 3. turn indicators on, off, or blink
     */
    uint8_t I1, I2, I3; //indicator state buffers
    I1 = 0; I2 = 0; I3 = 0; //initialize each to zero
    uint8_t received[2]; // receiver buffer
    for(;;)
    {
        //first, check if commands have come in
        //250 tick delay (250ms)
        xQueueReceive(xIND_Queue, received, 250);
        //process commands and set the indicator buffers
        switch(received[0]) //first check is the intended target
        {
            case 0x0: //do nothing/no target
                break;
            case 0x1: //Indicator 1
                I1 = received[1];
                break;
            case 0x2: //Indicator 2
                I2 = received[1];
                break;
            case 0x3: //Indicator 3
                I3 = received[1];
                break;
            case 0xff: //All indicators
                I1 = received[1];
                I2 = received[1];
                I3 = received[1];
                break;
        }
        //after processing commands, switch light state based on the commands
        switch(I1) //Indicator 1
        {
            case 0x0: //light off
                PORTC.OUTCLR = PIN3_bm;
                break;
            case 0x1: //light on
                PORTC.OUTSET = PIN3_bm;
                break;
            case 0x2: //blink
                PORTC.OUTTGL = PIN3_bm;
                break;
        }
        switch(I2) //Indicator 2
        {
            case 0x0: //light off
                PORTD.OUTCLR = PIN1_bm;
                break;
            case 0x1: //light on
                PORTD.OUTSET = PIN1_bm;
                break;
            case 0x2: //blink
                PORTD.OUTTGL = PIN1_bm;
                break;
        }
        switch(I3) //Indicator 3 
        {
            case 0x0: //light off
                PORTD.OUTCLR = PIN3_bm;
                break;
            case 0x1: //light on
                PORTD.OUTSET = PIN3_bm;
                break;
            case 0x2: //blink
                PORTD.OUTTGL = PIN3_bm;
                break;
        }
                
    }
}

static void prvMARTask(void * parameters)
{
    for(;;)
    {
        uint8_t colour_track = 0;// 0 = off, used to track colour requested
        uint8_t colour_light = 0;// 0 = off, used to track light colour
        uint8_t inlen = 0; //input length tracking
        uint8_t indbuffer[2]; //buffer for commands to indicators
        uint8_t buffer[MAX_MESSAGE_SIZE]; //message buffer
        uint8_t lightnum = 1; //keep track of how many lights are controlled
        uint8_t lightrem = 0; //track how many lights need to be confirmed
        //1. wait up to 500 ticks for input, need to grab MUTEX? MUTEX shouldn't be necessary for only a single task taking out
        //keep track of length as well
        inlen = xMessageBufferReceive(xDevice_Buffer, buffer, MAX_MESSAGE_SIZE, 500);
        //2. check input
        switch (inlen)
        {
            case 0: //no message
                break;
            case 1: //confirm byte from target
                if(colour_track == buffer[0])
                {
                    colour_light = colour_track;
                }
            case 2: //intertask message
                switch(buffer[0])
                {
                    case 0x04:    //button press
                        switch(buffer[1])
                        {
                            case 0x1: //button 1 (call this blue for now)
                                colour_track = 'B'; // blue lights
                                if(colour_track != colour_light)
                                lightrem = lightnum;
                                break;
                            case 0x2: //button 2 (call this green for now)
                                colour_track = 'G';
                                if(colour_track != colour_light)
                                lightrem = lightnum;
                                break;
                            case 0x3: //button 3 (call this yellow for now)
                                colour_track = 'Y';
                                if(colour_track != colour_light)
                                lightrem = lightnum;
                                break;
                        }
                        break;
                }
        }
        /* change colour check section:
         * check if there is a colour change
         * if there is a colour change, flash both lights, transmit colour change message
         */
        if(colour_light != colour_track)
        {
            //change light colours
            indbuffer[1] = 2; //flashing
            switch(colour_light)
            {
                case 'B':
                    indbuffer[0] = 1; //indicator 1
                    break;
                case 'G':
                    indbuffer[0] = 2; //indicator 2
                    break;
                case 'Y':
                    indbuffer[0] = 3; //indicator 3
                    break;
                default:
                    indbuffer[0] = 0; //no indicator
            }
            xQueueSendToBack(xIND_Queue, indbuffer, portMAX_DELAY);
            switch(colour_track)
            {
                case 'B':
                    indbuffer[0] = 1; //indicator 1
                    break;
                case 'G':
                    indbuffer[0] = 2; //indicator 2
                    break;
                case 'Y':
                    indbuffer[0] = 3; //indicator 3
                    break;
                default:
                    indbuffer[0] = 0; //no indicator
            }
            xQueueSendToBack(xIND_Queue, indbuffer, portMAX_DELAY);
            //lights should now be flashing
            //send colour change message to the RS485_output
            //send to relevant devices for now
            //last two bytes of message need to be 0x0401
            buffer[0] = colour_track;
            xMessageBufferSend(xBee_out_Buffer, buffer, 1, portMAX_DELAY);
        }
        /* colour confirmation section
         * once lightrem = 0, set light_colour to colour_track
         * turn off all indicators and turn on the correct one
         */
        if (lightrem == 0)
        {
            colour_light = colour_track;
            indbuffer[0] = 0xff;
            indbuffer[1] = 0;
            xQueueSendToBack(xIND_Queue, indbuffer, portMAX_DELAY);
            indbuffer[1] = 1;
            switch(colour_light)
            {
                case 'B':
                    indbuffer[0] = 1; //indicator 1
                    break;
                case 'G':
                    indbuffer[0] = 2; //indicator 2
                    break;
                case 'Y':
                    indbuffer[0] = 3; //indicator 3
                    break;
                default:
                    indbuffer[0] = 0; //no indicator
            }
            xQueueSendToBack(xIND_Queue, indbuffer, portMAX_DELAY);
        }
        /* message processing section complete:
         * confirmation check section
         * not yet implemented, since this is the most basic case for testing use
         * just send a message for the correct light colour if it has changed
         * (i.e, not confirmed)
         */
        
    }
}

ISR(PORTD_PORT_vect)
{
    /* PORTD interrupt:
     * 1. check which line the interrupt is on
     * 2. clear the interrupt
     * 3. send the button number to the button task
     */
    //1. check which pin the interrupt is on
    uint8_t pb[1] = {0};
    switch(PORTD.INTFLAGS)
    {
        case PIN6_bm: //button 1
            PORTD.INTFLAGS = PIN6_bm; //reset interrupt
            pb[0] = 0x01;
            break;
        case PIN5_bm: //button 2
            PORTD.INTFLAGS = PIN5_bm; //reset interrupt
            pb[0] = 0x02;
            break;
        case PIN4_bm: //button 3
            PORTD.INTFLAGS = PIN4_bm; //reset interrupt
            pb[0] = 0x03;
    }
    xQueueSendToFrontFromISR(xPB_Queue, pb, NULL);
}

ISR(USART0_RXC_vect)
{
    /* Receive complete interrupt
     * move received byte into byte buffer for RS485 in task
     */
    uint8_t buf[1];
    buf[0] = USART0.RXDATAL;
    xMessageBufferSendFromISR(xBee_in_Stream, buf, 1, NULL);
}
ISR(USART0_DRE_vect)
{
    /* Data Register empty Interrupt
     * 1. pull from output stream buffer and put in TX register until clear
     * 2. disable interrupt
     */
    uint8_t buf[1];
    if(xStreamBufferReceiveFromISR(xBee_out_Stream, buf, 1, NULL) == 0) //if end of message
        USART0.CTRLA &= ~USART_DREIE_bm; //disable interrupt
    else
        USART0.TXDATAL = buf[0];
}
ISR(USART0_TXC_vect)
{
    /* Transmission complete interrupts
     * 1. set semaphore
     * 2. clear interrupt flag
     */
    xSemaphoreGiveFromISR(xTXC, NULL); //send notification to output task
    USART0.STATUS |= USART_TXCIF_bm; //clear flag by writing a 1 to it
}