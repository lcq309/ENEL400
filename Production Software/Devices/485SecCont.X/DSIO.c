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
    
    uint8_t xPBTimerSet = 0;
    uint8_t xINDTimerSet = 0;
    
    //timer handles
    
    TimerHandle_t xPBTimer;
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
    
    xPB_Queue = xQueueCreate(3, sizeof(uint8_t)); //up to 3 button presses held
    xIND_Queue = xQueueCreate(3, 2 * sizeof(uint8_t)); // up to 3 Indicator Commands held
    xDeviceIN_Queue = xQueueCreate(3, 2 * sizeof(uint8_t)); // intertask messages to the device specific task
    
    //setup tasks
    
    xTaskCreate(dsIOInTask, "PBIN", 250, NULL, mainPBIN_TASK_PRIORITY, NULL);
    xTaskCreate(dsIOOutTask, "INDOUT", 250, NULL, mainINDOUT_TASK_PRIORITY, NULL);
    
    //setup timers
    xPBTimer = xTimerCreate("PBT", 500, pdFALSE, 0, vPBTimerFunc);
    xINDTimer = xTimerCreate("INDT", 50, pdTRUE, 0, vINDTimerFunc);
    
    //start the indicator timer
    xTimerStart(xINDTimer, 0);
}

void dsIOInTask (void * parameters)
{
    
    uint8_t last = 0; //variable for software anti-spam
    //initialize inputs
    PORTD.DIRCLR = PIN6_bm | PIN5_bm | PIN3_bm;
    //Then I will set up the multi-configure register for port D.
    PORTD.PINCONFIG = 0x3 | PORT_PULLUPEN_bm; //enable falling edge interrupt and pullup
    //update configuration for selected pins
    PORTD.PINCTRLUPD = PIN6_bm | PIN5_bm | PIN3_bm;
            
    //for now, this just reads button presses with a half second debounce delay to avoid spam.
    //block until a button press occurs, then check anti spam timer and reset timer
    //initialization complete, enter looping section.
    uint8_t input[1];
    uint8_t output[2] = {'P', 0}; //P for pushbutton in intertask messages
    for(;;)
    {
        //wait for input
        xQueueReceive(xPB_Queue, input, portMAX_DELAY);
        //check timer if the button pressed was the same
        if((last == input[0]) && (xPBTimerSet == 1))
        {
            output[1] = input[0];
            xSemaphoreGive(xNotify);
            xQueueSendToFront(xDeviceIN_Queue, output, portMAX_DELAY);
            xPBTimerSet = 0;
            xTimerReset(xPBTimer, portMAX_DELAY);
        }
        else if(last != input[0])
        {
            last = input[0];
            output[1] = input[0];
            xSemaphoreGive(xNotify);
            xQueueSendToFront(xDeviceIN_Queue, output, portMAX_DELAY);
            xPBTimerSet = 0;
            xTimerReset(xPBTimer, portMAX_DELAY);
        }
        
        //send message to inter-task queue
    }
    
}

void dsIOOutTask (void * parameters)
{
    //blink, flash, solid, etc.
    //this controls the three indicators on the console
    //blink should be somewhat slow, flash should be faster (mostly used for blue, initialization, and maybe errors)
    
    //indicator state buffers initialized to zero
    static uint8_t GREEN = 0; 
    static uint8_t YELLOW = 0; 
    static uint8_t BLUE = 0;
    
    //time buffers for flash and latches
    static uint8_t flash = 0; 
    static uint8_t blink = 0; 
    static uint8_t ms250 = 0;
    
    //setup IO
    
    PORTA.DIRSET = PIN7_bm;
    PORTC.DIRSET = PIN0_bm | PIN1_bm;
    
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
void vPBTimerFunc( TimerHandle_t xTimer )
{
    xPBTimerSet = 1;
}

void vINDTimerFunc( TimerHandle_t xTimer )
{
    xINDTimerSet = 1;
}

void dsioGreenOn(void)
{
    PORTC.OUTSET = PIN0_bm;
}
void dsioGreenOff(void)
{
    PORTC.OUTCLR = PIN0_bm;
}
void dsioGreenTGL(void)
{
    PORTC.OUTTGL = PIN0_bm;
}
    
void dsioYellowOn(void)
{
    PORTC.OUTSET = PIN1_bm;
}
void dsioYellowOff(void)
{
    PORTC.OUTCLR = PIN1_bm;
}
void dsioYellowTGL(void)
{
    PORTC.OUTTGL = PIN1_bm;
}
    
void dsioBlueOn(void)
{
    PORTA.OUTSET = PIN7_bm;
}
void dsioBlueOff(void)
{
    PORTA.OUTCLR = PIN7_bm;
}
void dsioBlueTGL(void)
{
    PORTA.OUTTGL = PIN7_bm;
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
            pb[0] = 'Y';
            break;
        case PIN5_bm: //button 2
            PORTD.INTFLAGS = PIN5_bm; //reset interrupt
            pb[0] = 'G';
            break;
        case PIN3_bm: //button 3
            PORTD.INTFLAGS = PIN3_bm; //reset interrupt
            pb[0] = 'B';
            break;
    }
    xQueueSendToFrontFromISR(xPB_Queue, pb, NULL);
}