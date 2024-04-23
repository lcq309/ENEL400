/* 
 * File:   DSIO.c
 * Author: Michael King
 * c file that includes the Device specific I/O tasks
 * as well as functions that are defined for modular tasks that interact with hardware
 * Created on April 23, 2024
 */

#include "DSIO.h"

void DSIOSetup()
{
    //setup Queues
    
    xPB_Queue = xQueueCreate(3, sizeof(uint8_t)); //up to 3 button presses held
    xIND_Queue = xQueueCreate(3, 2 * sizeof(uint8_t)); // up to 3 Indicator Commands held
    xDeviceIN_Queue = xQueueCreate(3, 2 * sizeof(uint8_t)); // intertask messages to the device specific task
    
    //setup tasks
    
    xTaskCreate(dsIOInTask, "PBIN", 250, NULL, mainPBIN_TASK_PRIORITY, NULL);
    xTaskCreate(dsIOOutTask, "INDOUT", 250, NULL, mainINDOUT_TASK_PRIORITY, NULL);
}

static void dsIOInTask (void * parameters)
{
    //for now, this just reads button presses with a half second debounce delay to avoid spam.
    //block until a button press occurs, then check anti spam timer and reset timer
    
    //wait for input
    
    //check timer if the button pressed was the same
    
    //send message to inter-task queue
    
}

static void dsIOOutTask (void * parameters)
{
    //blink, flash, solid, etc.
    //this controls the three indicators on the console
    //blink should be somewhat slow, flash should be faster (mostly used for blue, initialization, and maybe errors)
    
    //indicator state buffers initialized to zero
    uint8_t GREEN = 0; uint8_t YELLOW = 0; uint8_t BLUE = 0;
    
    //time buffers for flash and latches
    uint8_t flash = 0; uint8_t blink = 0; uint8_t ms250 = 0;
    
    //setup IO
    
    PORTA.DIRSET = PIN7_bm;
    PORTC.DIRSET = PIN0_bm | PIN1_bm;
    
    //receiver buffer
    uint8_t received[2];
    
    //running loop
    for(;;)
    {
        //first, check for commands from other tasks (hold for 50ms)
        if(xQueueReceive(xIND_Queue, received, 50) == pdTRUE)
        {
        switch(received[0]) //first check is the intended target
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
        //set blink and flash
        blink = 1;
        flash = 1;
    }
}

void RS485TR(uint8_t dir)
{
    //set transceiver direction
    switch(dir)
    {
        case 'T': //transmit
            break;
        case 'R': //receive
            break;
        default: //incorrect command
            break;
    }
}

void dsioGreenOn(void)
{
    PORTA.OUTSET = PIN7_bm;
}
void dsioGreenOff(void)
{
    PORTA.OUTCLR = PIN7_bm;
}
void dsioGreenTGL(void)
{
    PORTA.OUTTGL = PIN7_bm;
}
    
void dsioYellowOn(void)
{
    PORTC.OUTSET = PIN0_bm;
}
void dsioYellowOff(void)
{
    PORTC.OUTCLR = PIN0_bm;
}
void dsioYellowTGL(void)
{
    PORTC.OUTTGL = PIN0_bm;
}
    
void dsioBlueOn(void)
{
    PORTC.OUTSET = PIN1_bm;
}
void dsioBlueOff(void)
{
    PORTC.OUTCLR = PIN1_bm;
}
void dsioBlueTGL(void)
{
    PORTC.OUTTGL = PIN1_bm;
}

//interrupts go here