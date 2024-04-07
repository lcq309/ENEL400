/* 
 * File:   main.c - Wireless Light generic
 * Author: Michael King
 * MVP version
 *
 * The purpose of this is to create a minimum viable running code for the Wireless light
 * controllers, this code is for the general case.
 * Created on March 26, 2024
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
static const uint8_t TARGET_ADDRESS[8] = {0x00,0x13,0xA2,0x00,0x42,0x37,0xE2,0xD3};
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
static void prvLightOutTask ( void *parameters );
static void prvWLDTask ( void *parameters );


//Mutexes

static SemaphoreHandle_t xDeviceBuffer_MUTEX = NULL;

//Semaphores

static SemaphoreHandle_t xTXC = NULL;

//event groups

static EventGroupHandle_t xInit = NULL;

//stream handles

static StreamBufferHandle_t xBee_in_Stream = NULL;
static StreamBufferHandle_t xBee_out_Stream = NULL;
static MessageBufferHandle_t xBee_out_Buffer = NULL;
static MessageBufferHandle_t xDevice_Buffer = NULL;

//queue handles

static QueueHandle_t xLIGHT_Queue = NULL;

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
    
    xLIGHT_Queue = xQueueCreate(3, 2 * sizeof(uint8_t)); // up to 3 Indicator Commands held
    
    //setup mutex(es)
    
    xDeviceBuffer_MUTEX = xSemaphoreCreateMutex();
    
    //setup semaphore
    
    xTXC = xSemaphoreCreateBinary();
    
    //setup tasks
    
    xTaskCreate(prvXBeeOutTask, "RSOUT", 500, NULL, mainRS485OUT_TASK_PRIORITY, NULL);
    xTaskCreate(prvXBeeInTask, "RSIN", 400, NULL, mainRS485IN_TASK_PRIORITY, NULL);
    xTaskCreate(prvLightOutTask, "INDOUT", 250, NULL, mainINDOUT_TASK_PRIORITY, NULL);
    xTaskCreate(prvWLDTask, "WLD", 600, NULL, mainWBM_TASK_PRIORITY, NULL);
    
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
    /*XBee_Length[0] = 0;
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
    checksum[0] = 0xff - checksum[0];
    xStreamBufferSend(xBee_out_Stream, checksum, 1, portMAX_DELAY);
    }
    */
    //message now assembled, send it by loading output register and enabling DRE interrupt
    USART0.TXDATAL = buffer[0];
    //enable DRE interrupt
    USART0.CTRLA |= USART_DREIE_bm;
    //wait for TXcomplete notification
    xSemaphoreTake(xTXC, portMAX_DELAY);
    //end of loop, start over now
    }}

static void prvXBeeInTask(void * parameters)
{   //there is only one sender, we should be able to basically ignore all header stuff and just send the message byte to the controller task
    uint8_t byte_buffer[1];
    uint8_t buffer[MAX_MESSAGE_SIZE];
    uint8_t length[2];
    xStreamBufferReceive(xBee_in_Stream, byte_buffer, 1, portMAX_DELAY);
    /*
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
    */
    xSemaphoreTake(xDeviceBuffer_MUTEX, portMAX_DELAY);
    //send to device buffer
    xMessageBufferSend(xDevice_Buffer, byte_buffer, 1, portMAX_DELAY);
    //release device MUTEX
    xSemaphoreGive(xDeviceBuffer_MUTEX);
}

static void prvLightOutTask(void * parameters)
{
    // first I will initialize the pins as outputs
    PORTC.DIRSET = PIN2_bm | PIN3_bm;
    PORTD.DIRSET = PIN0_bm | PIN1_bm;
    
    /* Indicator out loop:
     * 1. wait for message on input queue
     * 2. process message
     * 3. turn indicators on, off, or blink
     */
    uint8_t output = 0; //initialize as none
    uint8_t blink = 0; //output flash or solid 
    uint8_t received[2]; // receiver buffer
    for(;;)
    {
        //first, check if commands have come in
        //250 tick delay (250ms)
        xQueueReceive(xLIGHT_Queue, received, 250);
        output = received[0];
        blink = received[1];
        //after processing commands, switch light state based on the commands
        switch(output) //Turn lights on or off
        {
            case 0x0: //light off
                PORTC.OUTCLR = PIN2_bm | PIN3_bm;
                PORTD.OUTCLR = PIN0_bm | PIN1_bm;
                break;
            case 'G': //Green
                PORTC.OUTCLR = PIN2_bm;
                PORTD.OUTCLR = PIN0_bm | PIN1_bm;
                switch(blink)
                {
                    case 0x1: //solid
                        PORTC.OUTSET = PIN3_bm;
                        break;
                    case 0x2: //blink
                        PORTC.OUTTGL = PIN3_bm;
                        break;
                }
                break;
            case 'R': //Red
                PORTC.OUTCLR = PIN3_bm;
                PORTD.OUTCLR = PIN0_bm | PIN1_bm;
                switch(blink)
                {
                    case 0x1: //solid
                        PORTC.OUTSET = PIN2_bm;
                        break;
                    case 0x2: //blink
                        PORTC.OUTTGL = PIN2_bm;
                        break;
                }
                break;
            case 'Y': //Yellow
                PORTC.OUTCLR = PIN3_bm | PIN2_bm;
                PORTD.OUTCLR = PIN0_bm;
                switch(blink)
                {
                    case 0x1: //solid
                        PORTD.OUTSET = PIN1_bm;
                        break;
                    case 0x2: //blink
                        PORTD.OUTTGL = PIN1_bm;
                        break;
                }
                break;
            case 'B': //Blue
                PORTC.OUTCLR = PIN2_bm | PIN3_bm;
                PORTD.OUTCLR = PIN1_bm;
                switch(blink)
                {
                    case 0x1: //solid
                        PORTD.OUTSET = PIN0_bm;
                        break;
                    case 0x2: //blink
                        PORTD.OUTTGL = PIN0_bm;
                        break;
                }
                break;
        }
    }
}

static void prvWLDTask(void * parameters)
{
    /* Wired Light Driver:
     * 1. check for input (blocks up to 50 ticks?)
     * 2. perform input checking
     * 3. turn on appropriate light
     * 4. reply to light being turned on
     */
    uint8_t colour_light = 0;// 0 = off, used to track light colour
    uint8_t inlen = 0; //input length tracking
    uint8_t lightbuffer[2]; //buffer for commands to indicators
    uint8_t buffer[MAX_MESSAGE_SIZE]; //message buffer
    //uint8_t lights[20]; //one controller can track up to 20 lights?
    uint8_t lightnum = 0; //keep track of how many lights are controlled
    uint8_t lightrem = 0; //track how many lights need to be confirmed
    uint8_t controllers[20]; //when implemented
    //uint8_t broadcast[20]; //20 broadcast channel devices
    //uint8_t menus[20]; //up to 20 menus
    for(;;)
    {
        //1. wait up to 50 ticks for input, need to grab MUTEX?
        //grab device buffer MUTEX
        inlen = 0;
        inlen = xMessageBufferReceive(xDevice_Buffer, buffer, MAX_MESSAGE_SIZE, 50);
        //2. check input
        switch (inlen)
        {
            case 0: //no message
                break;
            case 1: //command from sender
                if(buffer[0] != colour_light) //if colour is changing
                {
                    colour_light = buffer[0];
                    switch(buffer[0])
                    {
                        case 'B': //Blue (flash implied)
                            lightbuffer[0] = buffer[0];
                            lightbuffer[1] = 0x2;
                            xQueueSend(xLIGHT_Queue, lightbuffer, portMAX_DELAY);
                        break;
                        case 'G': //Green (not flash)
                            lightbuffer[0] = buffer[0];
                            lightbuffer[1] = 0x1;
                            xQueueSend(xLIGHT_Queue, lightbuffer, portMAX_DELAY);
                        break;
                        case 'Y': //Yellow (not flash)
                            lightbuffer[0] = buffer[0];
                            lightbuffer[1] = 0x1;
                            xQueueSend(xLIGHT_Queue, lightbuffer, portMAX_DELAY);
                        break;
                        case 'R': //Red (not flash)
                            lightbuffer[0] = buffer[0];
                            lightbuffer[1] = 0x1;
                            xQueueSend(xLIGHT_Queue, lightbuffer, portMAX_DELAY);
                        break;
                    }
                }
                //now send response
                uint8_t response[1];
                response[0] = buffer[0];
                xMessageBufferSend(xBee_out_Buffer, response, 1, portMAX_DELAY);
                break;
        }
    }
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