/* 
 * File:   DSIO.c
 * Author: Michael King
 * c file that includes the Device specific I/O tasks
 * as well as functions that are defined for modular tasks that interact with hardware
 * Created on April 23, 2024
 */

#include "DSIO.h"
    //Semaphores
    
    extern SemaphoreHandle_t xNotify;

    //timer globals
    
    uint8_t xINDTimerSet = 0;
    
    //timer handles
    
    TimerHandle_t xINDTimer;
    
    //queue handles

    QueueHandle_t xPB_Queue;
    QueueHandle_t xIND_Queue;
    QueueHandle_t xDeviceIN_Queue;
    
void DSIOSetup()
{
    //485 R/W pin setup
    PORTD.DIRSET = PIN7_bm;
    PORTD.OUTCLR = PIN7_bm;
    
    //Indicator pin setup
    PORTA.DIRSET = PIN7_bm;
    PORTC.DIRSET = PIN0_bm | PIN1_bm;
    
    //setup Queues
    
    xPB_Queue = xQueueCreate(1, sizeof(uint8_t)); //up to 1 button presses held
    xIND_Queue = xQueueCreate(4, 2 * sizeof(uint8_t)); // up to 4 Indicator Commands held
    xDeviceIN_Queue = xQueueCreate(3, 2 * sizeof(uint8_t)); // intertask messages to the device specific task
    
    //setup tasks
    
    xTaskCreate(dsIOInTask, "PBIN", 250, NULL, mainPBIN_TASK_PRIORITY, NULL);
    xTaskCreate(dsIOOutTask, "INDOUT", 250, NULL, mainINDOUT_TASK_PRIORITY, NULL);
    
    //setup timers
    xINDTimer = xTimerCreate("INDT", 50, pdTRUE, 0, vINDTimerFunc);
    
    //start the indicator timer
    xTimerStart(xINDTimer, 0);
}

void dsIOInTask (void * parameters)
{
    //initialize inputs
    PORTD.DIRCLR = PIN6_bm | PIN5_bm;
    //Then I will set up the multi-configure register for port D.
    PORTD.PINCONFIG = 0x3 | PORT_PULLUPEN_bm; //enable falling edge interrupt and pullup
    //update configuration for selected pins
    PORTD.PINCTRLUPD = PIN6_bm | PIN5_bm;
            
    //the off button works the same as a normal controller, but the stop button 
    //sets the stop state which is not released until the stop button is released
    //this can be checked each time the loop runs until the button is released
    uint8_t input[1];
    uint8_t output[2] = {'P', 0}; //P for pushbutton in intertask messages
    uint8_t stopState = 0; // 0 is clear, 'S' is stopped, 'R' is released
    for(;;)
    {
        //wait for input (up to 25ms)
        xQueueReceive(xPB_Queue, input, 25);
        if(input[0] == 'R') //if red, set stop state
        {
            output[1] = 'S'; //stop
            xQueueSendToFront(xDeviceIN_Queue, output, portMAX_DELAY);
            stopState = 'R'; //S for stopped
            xSemaphoreGive(xNotify);
        }
        else if(input[0] == 'O') //off button
        {
            output[1] = 'O'; //O for off
            xQueueSendToBack(xDeviceIN_Queue, output, portMAX_DELAY);
            xSemaphoreGive(xNotify);
        }
        else if(stopState == 'S') //if stopped, check to see if it has been released yet
        {
            if(dsioStopButt() == 0)
            {
                stopState = 'R'; //released, send a release message
                output[1] = 'Y'; //release the stop state locally
                xQueueSendToBack(xDeviceIN_Queue, output, portMAX_DELAY);
                xSemaphoreGive(xNotify);
            }
        }
        else if(stopState == 'R')
            stopState = 0;
    }
    
}

void dsIOOutTask (void * parameters)
{
    //blink, flash, solid, etc.
    //this controls the three indicators on the console
    //blink should be somewhat slow, flash should be faster (mostly used for blue, initialization, and maybe errors)
    
    //indicator state buffers initialized to zero
    static uint8_t RED = 0;
    
    //time buffers for flash and latches
    static uint8_t flash = 0; 
    static uint8_t blink = 0; 
    static uint8_t ms250 = 0;
    
    //setup IO

    PORTC.DIRSET = PIN1_bm;
    
    //receiver buffer
    uint8_t received[2];
    
    //running loop
    for(;;)
    {
        //first, check for commands from other tasks (hold for 50ms)
        if(xQueueReceive(xIND_Queue, received, 20) == pdTRUE)
        {
        switch(received[0]) //first check the intended target
        {
            case 0x0: //do nothing/no target
                break;
            case 'R': //Green indicator
                RED = received[1];
                break;
            case 0xff: //All indicators
                RED = received[1];
                break;
        }
        }
        //if timer has triggered, increment ms250 and reset flash and blink timers
        if(xINDTimerSet == 1)
        {
            ms250++;
            if(ms250 == 5)
            {
                ms250 = 0;
                blink = 0;
            }
            flash = 0;
            xINDTimerSet = 0;
        }
        //process green first
        switch(RED)
        {
            case 'B': //blink
                if(blink == 0 && ms250 == 0)
                    dsioRedTGL();
            break;
            
            case 'F': //flash
                if(flash == 0)
                    dsioRedTGL();
            break;
            
            case 'D': //double flash
                if(flash == 0)
                {
                    dsioRedOn();
                    vTaskDelay(5);
                    dsioRedTGL();
                    vTaskDelay(5);
                    dsioRedTGL();
                    vTaskDelay(5);
                    dsioRedOff();
                }
                break;
                
            case 'W': //warning flash (used for lockout warning)
                dsioRedOn();
                vTaskDelay(5);
                dsioRedTGL();
                vTaskDelay(5);
                dsioRedTGL();
                vTaskDelay(5);
                dsioRedTGL();
                vTaskDelay(5);
                dsioRedTGL();
                vTaskDelay(5);
                dsioRedTGL();
                vTaskDelay(5);
                dsioRedTGL();
                vTaskDelay(5);
                dsioRedOff();
                break;
                
                            
            case 'S': //solid
                dsioRedOn();
            break;
            
            case 'O': //off
                dsioRedOff();
            break;
        }
        //set blink and flash
        blink = 1;
        flash = 1;
    }
}

//RS485 in/out
void RS485TR(uint8_t dir)
{
    //set transceiver direction
    switch(dir)
    {
        case 'T': //transmit
            PORTD.OUTSET = PIN7_bm;
            break;
        case 'R': //receive
            PORTD.OUTCLR = PIN7_bm;
            break;
        default: //incorrect command
            break;
    }
}

//timer callback functions

void vINDTimerFunc( TimerHandle_t xTimer )
{
    xINDTimerSet = 1;
}

void dsioRedOn(void)
{
    PORTC.OUTSET = PIN1_bm;
}
void dsioRedOff(void)
{
    PORTC.OUTCLR = PIN1_bm;
}
void dsioRedTGL(void)
{
    PORTC.OUTTGL = PIN1_bm;
}

uint8_t dsioStopButt(void)
{
    return(!!(PORTD.IN & PIN6_bm));
}

//interrupts go here

ISR(PORTD_PORT_vect)
{
    /* PORTD interrupt:
     * 1. check which line the interrupt is on
     * 2. clear the interrupt
     * 3. send the button colour to the button task
     */
    //1. check which pin the interrupt is on
    uint8_t pb[1] = {0};
    switch(PORTD.INTFLAGS)
    {
        case PIN6_bm: //button 1
            PORTD.INTFLAGS = PIN6_bm; //reset interrupt
            pb[0] = 'R';
            break;
        case PIN5_bm: //button 2
            PORTD.INTFLAGS = PIN5_bm; //reset interrupt
            pb[0] = 'O';
            break;
    }
    xQueueSendToBackFromISR(xPB_Queue, pb, NULL);
}