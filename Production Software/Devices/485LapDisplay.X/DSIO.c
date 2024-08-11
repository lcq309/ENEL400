/* 
 * File:   DSIO.c
 * Author: Michael King
 * c file that includes the Device specific I/O tasks
 * as well as functions that are defined for modular tasks that interact with hardware
 * Created on July 5, 2024
 */

#include "DSIO.h"
    //Semaphores
    
    extern SemaphoreHandle_t xNotify;

    //timer globals
    
    uint8_t xINDTimerSet = 0;
    
    //timer handles
    
    TimerHandle_t xINDTimer;
    
    //queue handles

    QueueHandle_t xIND_Queue;
    QueueHandle_t xDeviceIN_Queue;
    
    
void DSIOSetup()
{
    //485 R/W pin setup
    PORTA.DIRSET = PIN2_bm;
    PORTA.OUTCLR = PIN2_bm;
    
    //output shift register setup
    
    InitShiftOut();
    
    //setup Queues
    
    xIND_Queue = xQueueCreate(4, 3 * sizeof(uint8_t)); // up to 4 Indicator Commands held
    xDeviceIN_Queue = xQueueCreate(3, 2 * sizeof(uint8_t)); // intertask messages to the device specific task
    
    
    //setup tasks
    
    xTaskCreate(dsIOOutTask, "INDOUT", 250, NULL, mainINDOUT_TASK_PRIORITY, NULL);
    
    //setup timers
    xINDTimer = xTimerCreate("INDT", 250, pdTRUE, 0, vINDTimerFunc);
    
    //start the indicator timer
    xTimerStart(xINDTimer, 0);
}

void dsIOOutTask (void * parameters)
{
    //blink, flash, solid, etc.
    //this controls the three indicators on the console
    //blink should be somewhat slow, flash should be faster (mostly used for blue, initialization, and maybe errors)
    
    //digit state buffer initialized to zero.
    uint8_t DigitOne = 0;
    uint8_t DigitTwo = 0;
    volatile uint8_t displaytype = 0; //flashing, solid, off
    uint8_t state = 0; //for flashing and tracking the current state
    
    //time buffers for flash and latches
    static uint8_t flash = 0; 
    static uint8_t blink = 0; 
    static uint8_t ms250 = 0;
    
    //setup IO
    
    //receiver buffer
    uint8_t received[3];

    //output buffer
    uint8_t output[9] = {0,0,0,0,0,0,0,0,0};
    
    //working digit buffer
    uint16_t digit = 0;
    
    //running loop
    for(;;)
    {
        //first, check for commands from other tasks (hold for 50ms)
        if(xQueueReceive(xIND_Queue, received, 50) == pdTRUE)
        {
            //set the digits and mode
            DigitTwo = received[0];
            DigitOne = received[1];
            displaytype = received[2];
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
        //process based on display mode
        switch(displaytype)
        {
            case 'S': //solid
                state = 1;
                break;

            case 'F': //flashing
                if(flash == 0)
                {
                    if(state == 1)
                        state = 0;
                    else
                        state = 1;
                }
                break;

            case 'O': //off
                state = 0;
                break;
        }
        switch(state) //display is either on or off, based on state
        {
            case 1: //on
                ShiftOut(ShiftTranslate(DigitTwo));
                ShiftOut(ShiftTranslate(DigitOne));
                LTCHOut();
                break;
                
            case 0: //off
                CLROut();
                LTCHOut();
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
            PORTA.OUTSET = PIN2_bm;
            break;
        case 'R': //receive
            PORTA.OUTCLR = PIN2_bm;
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

//interrupts go here