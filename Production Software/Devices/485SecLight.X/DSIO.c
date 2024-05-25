/* 
 * File:   DSIO.c
 * Author: Michael King
 * c file that includes the Device specific I/O tasks
 * as well as functions that are defined for modular tasks that interact with hardware
 * Created on April 23, 2024
 */

#include "DSIO.h"
//timer globals
    
    uint8_t xINDTimerSet;
    
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
    
    //setup Queues
    
    xIND_Queue = xQueueCreate(3, 2 * sizeof(uint8_t)); // up to 3 Indicator Commands held
    xDeviceIN_Queue = xQueueCreate(3, 2 * sizeof(uint8_t)); // intertask messages to the device specific task
    
    //setup tasks
    
    xTaskCreate(dsIOOutTask, "INDOUT", 350, NULL, mainINDOUT_TASK_PRIORITY, NULL);
    
    //setup timers

    xINDTimer = xTimerCreate("INDT", 50, pdTRUE, 0, vINDTimerFunc);
    
    //start the indicator timer
    xTimerStart(xINDTimer, 0);
}

void dsIOOutTask (void * parameters)
{
    //blink, flash, solid, etc.
    //this controls the three indicators on the console
    //blink should be somewhat slow, flash should be faster (mostly used for blue, initialization, and maybe errors)
    
    //indicator state buffers initialized to zero
    uint8_t GREEN = 0; uint8_t YELLOW = 0; uint8_t BLUE = 0; uint8_t RED = 0;
    
    //time buffers for flash and latches
    uint8_t flash = 0; uint8_t blink = 0; uint8_t ms250 = 0;
    
    //setup IO
    
    PORTC.DIRSET = PIN2_bm | PIN3_bm;
    PORTD.DIRSET = PIN0_bm | PIN1_bm; 
    
    //receiver buffer
    uint8_t received[2];
    
    //running loop
    for(;;)
    {
        //first, check for commands from other tasks (hold for 50ms)
        if(xQueueReceive(xIND_Queue, received, 25) == pdTRUE)
        {
        switch(received[0]) //first check the intended target
        {
            case 0x0: //do nothing/no target
                break;
            case 'G': //Green indicator
                GREEN = received[1];
                break;
            case 'Y': //Yellow indicator
                YELLOW = received[1];
                break;
            case 'B': //Blue indicator
                BLUE = received[1];
                break;
            case 'R': //Red indicator
                RED = received[1];
                break;
            case 0xff: //All indicators
                GREEN = received[1];
                YELLOW = received[1];
                BLUE = received[1];
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
        switch(GREEN)
        {
            case 'B': //blink
                if(blink == 0 && ms250 == 0)
                    dsioGreenTGL();
            break;
            
            case 'F': //flash
                if(flash == 0)
                    dsioGreenTGL();
            break;
            
            case 'S': //solid
                dsioGreenOn();
            break;
            
            case 'O': //off
                dsioGreenOff();
            break;
        }
        //process blue
        switch(BLUE)
        {
            case 'B': //blink
                if(blink == 0 && ms250 == 0)
                    dsioBlueTGL();
            break;
            
            case 'F': //flash
                if(flash == 0)
                    dsioBlueTGL();
            break;
            
            case 'S': //solid
                dsioBlueOn();
            break;
            
            case 'O': //off
                dsioBlueOff();
            break;
        }
        //process yellow
        switch(YELLOW)
        {
            case 'B': //blink
                if(blink == 0 && ms250 == 0)
                    dsioYellowTGL();
            break;
            
            case 'F': //flash
                if(flash == 0)
                    dsioYellowTGL();
            break;
            
            case 'S': //solid
                dsioYellowOn();
            break;
            
            case 'O': //off
                dsioYellowOff();
            break;
        }
        //process blue
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
            PORTA.OUTSET = PIN2_bm;
            break;
        case 'R': //receive
            PORTA.OUTCLR = PIN2_bm;
            break;
        default: //incorrect command
            break;
    }
}

void vINDTimerFunc( TimerHandle_t xTimer )
{
    xINDTimerSet = 1;
}

void dsioGreenOn(void)
{
    PORTC.OUTSET = PIN3_bm;
}
void dsioGreenOff(void)
{
    PORTC.OUTCLR = PIN3_bm;
}
void dsioGreenTGL(void)
{
    PORTC.OUTTGL = PIN3_bm;
}
    
void dsioYellowOn(void)
{
    PORTD.OUTSET = PIN1_bm;
}
void dsioYellowOff(void)
{
    PORTD.OUTCLR = PIN1_bm;
}
void dsioYellowTGL(void)
{
    PORTD.OUTTGL = PIN1_bm;
}
    
void dsioBlueOn(void)
{
    PORTD.OUTSET = PIN0_bm;
}
void dsioBlueOff(void)
{
    PORTD.OUTCLR = PIN0_bm;
}
void dsioBlueTGL(void)
{
    PORTD.OUTTGL = PIN0_bm;
}

void dsioRedOn(void)
{
    PORTC.OUTSET = PIN2_bm;
}
void dsioRedOff(void)
{
    PORTC.OUTCLR = PIN2_bm;
}
void dsioRedTGL(void)
{
    PORTC.OUTTGL = PIN2_bm;
}
//interrupts go here
