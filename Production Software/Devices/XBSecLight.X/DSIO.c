/* 
 * File:   DSIO.c
 * Author: Michael King
 * c file that includes the Device specific I/O tasks
 * as well as functions that are defined for modular tasks that interact with hardware
 * Created on July 7, 2024
 */

#include "DSIO.h"
    
    //Semaphores
    
    extern SemaphoreHandle_t xNotify;
    
    //timer globals
    
    uint8_t xINDTimerSet;
    uint8_t xSTATTimerSet;
    uint8_t xBATTTimerSet = 0;
    
    //timer handles
    
    TimerHandle_t xINDTimer;
    TimerHandle_t xSTATTimer;
    TimerHandle_t xBATTTimer;
    
    //Semaphores
    
    SemaphoreHandle_t xCircCheckTrig;
    SemaphoreHandle_t xBattCheckTrig;
    
    //queue handles

    QueueHandle_t xIND_Queue;
    QueueHandle_t xDeviceIN_Queue;
    QueueHandle_t xSTAT_Queue;
    
void DSIOSetup()
{
    //prepare ADC
    ADC_init();
    
    //setup Queues
    
    xIND_Queue = xQueueCreate(3, 2 * sizeof(uint8_t)); // up to 3 Indicator Commands held
    xDeviceIN_Queue = xQueueCreate(3, 2 * sizeof(uint8_t)); // intertask messages to the device specific task
    xSTAT_Queue = xQueueCreate(1, 1 * sizeof(uint16_t)); // messages from RESRDY
    
    //setup tasks
    
    xTaskCreate(dsIOOutTask, "INDOUT", 350, NULL, mainINDOUT_TASK_PRIORITY, NULL);
    xTaskCreate(dsIOSTATUS, "STAT", 150, NULL, mainSTAT_TASK_PRIORITY, NULL);
    
    //setup timers

    xINDTimer = xTimerCreate("INDT", 250, pdTRUE, 0, vINDTimerFunc);
    xSTATTimer = xTimerCreate("STAT", 500, pdFALSE, 0, vCircCheckTimerFunc);
    xBATTTimer = xTimerCreate("STAT", 500, pdFALSE, 0, vBattCheckTimerFunc);
    
    //setup the semaphore
    xBattCheckTrig = xSemaphoreCreateBinary();
    xCircCheckTrig = xSemaphoreCreateBinary();
    
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
            //should indicate that a change is occurring for all cases except zero and incorrect
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
                case 0xfe: //All but status
                    GREEN = received[1];
                    YELLOW = received[1];
                    BLUE = received[1];
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
        switch(GREEN)
        {
            case 'B': //blink
                if(blink == 0 && ms250 == 0)
                {
                    dsioGreenTGL();
                    xSemaphoreGive(xCircCheckTrig);
                }
            break;
            
            case 'F': //flash
                if(flash == 0)
                {
                    dsioGreenTGL();
                    xSemaphoreGive(xCircCheckTrig);
                }
            break;
            
            case 'S': //solid
                dsioGreenOn();
                xSemaphoreGive(xCircCheckTrig);
            break;
            
            case 'D': //double flash
                if(flash == 0)
                {
                    dsioGreenTGL();
                    xSemaphoreGive(xCircCheckTrig);
                    vTaskDelay(25);
                    dsioGreenTGL();
                }
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
                {
                    dsioBlueTGL();
                    xSemaphoreGive(xCircCheckTrig);
                }
            break;
            
            case 'F': //flash
                if(flash == 0)
                {
                    dsioBlueTGL();
                    xSemaphoreGive(xCircCheckTrig);
            
                }
                break;
            
            case 'D': //double flash
                if(flash == 0)
                {
                    dsioBlueTGL();
                    xSemaphoreGive(xCircCheckTrig);
                    vTaskDelay(25);
                    dsioBlueTGL();
                }
                break;
            
            case 'S': //solid
                dsioBlueOn();
                xSemaphoreGive(xCircCheckTrig);
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
                {
                    dsioYellowTGL();
                    xSemaphoreGive(xCircCheckTrig);
                }
            break;
            
            case 'F': //flash
                if(flash == 0)
                {
                    dsioYellowTGL();
                    xSemaphoreGive(xCircCheckTrig);
                }
            break;
            
            case 'D': //double flash
                if(flash == 0)
                {
                    dsioYellowTGL();
                    xSemaphoreGive(xCircCheckTrig);
                    vTaskDelay(25);
                    dsioYellowTGL();
                }
                break;
            
            case 'S': //solid
                dsioYellowOn();
                xSemaphoreGive(xCircCheckTrig);
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
                {
                    dsioRedTGL();
                    xSemaphoreGive(xCircCheckTrig);
                }
            break;
            
            case 'F': //flash
                if(flash == 0)
                {
                    dsioRedTGL();
                    xSemaphoreGive(xCircCheckTrig);
                }
            break;
            
            case 'D': //double flash
                if(flash == 0)
                {
                    dsioRedTGL();
                    xSemaphoreGive(xCircCheckTrig);
                    vTaskDelay(25);
                    dsioRedTGL();
                }
                break;
            
            case 'S': //solid
                dsioRedOn();
                xSemaphoreGive(xCircCheckTrig);
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


void dsIOSTATUS (void * parameters)
{
    for(;;)
    {
        volatile uint8_t output = 0;
        uint8_t outbuffer[2] = {'S', 'L'};
        volatile uint16_t received[1];
        //block on manual trigger semaphore
        if(xSemaphoreTake(xCircCheckTrig, 50) == pdTRUE)
        {
            //check pin output states to see if there should be anything right now
            //pins are PC3, PD1, PD0 and PC2 for outputs
            if((PORTC.OUT & PIN3_bm) || (PORTC.OUT & PIN2_bm) || (PORTD.OUT & PIN1_bm) || (PORTD.OUT & PIN0_bm)) //if any outputs are live
                output = 1;
            //manual check requested, start check and reset the periodic timer
            LightCheck();
            xSTATTimerSet = 0;
            xTimerReset(xSTATTimer, 0);
            //wait for result before moving on
            xQueueReceive(xSTAT_Queue, received, portMAX_DELAY); //check output after starting the sample, but before blocking
            //check against reference value of 31 (~25mV over resistor) and light state
            if((received[0] < 31) && (output == 1))
            {
                //this is an error case, send the error out to the main task
                //error is S L
                outbuffer[1] = 'L';
                xQueueSendToBack(xDeviceIN_Queue, outbuffer, 10);
            }
            else if((received[0] > 31) && (output == 0))
            {
                //this is an error case
                outbuffer[1] = 'L';
                xQueueSendToBack(xDeviceIN_Queue, outbuffer, 10);
            }
        }
        else //if not a manual trigger, then check timer and do the periodic if the time is right
        {
            if(xSTATTimerSet == 1)
            {
                //check pin output states to see if there should be anything right now
                //pins are PC3, PD1, PD0 and PC2 for outputs
                if((PORTC.OUT & PIN3_bm) || (PORTC.OUT & PIN2_bm) || (PORTD.OUT & PIN1_bm) || (PORTD.OUT & PIN0_bm)) //if any outputs are live
                    output = 1;
                LightCheck();
                xSTATTimerSet = 0;
                xTimerReset(xSTATTimer, 0);
                xQueueReceive(xSTAT_Queue, received, portMAX_DELAY); //check output after starting the sample, but before blocking
                //check against reference value of 31 (~25mV over resistor) and light state
                if((received[0] < 31) && (output == 1))
                {
                    //this is an error case, send the error out to the main task
                    //error is S L
                    outbuffer[1] = 'L';
                    xQueueSendToBack(xDeviceIN_Queue, outbuffer, 10);
                }
                else if((received[0] > 31) && (output == 0))
                {
                    //this is an error case
                    outbuffer[1] = 'L';
                    xQueueSendToBack(xDeviceIN_Queue, outbuffer, 10);
                }
            }
        }
        //battery check stuff here, lower priority than the light check
        if((xSemaphoreTake(xBattCheckTrig, 0) == pdTRUE) || (xBATTTimerSet == 1))
        {
            //check the battery voltage
            VoltageCheck();
            xBATTTimerSet = 0;
            xTimerReset(xBATTTimer, 0);
            //wait for result before moving on
            xQueueReceive(xSTAT_Queue, received, portMAX_DELAY); //check output after starting the sample, but before blocking
            //check against reference value of 2402 (~1.935V over resistor)
            if(received[0] < 2643)
            {
                //low battery state, send the message to the main task
                outbuffer[1] = 'B';
                xQueueSendToBack(xDeviceIN_Queue, outbuffer, 10);
            }
        }
    }
}

void LightCheck(void)
{
    ADC0.MUXPOS = ADC_MUXPOS_AIN2_gc;
    ADC0.COMMAND = 0x1;
}
void VoltageCheck(void)
{
    ADC0.MUXPOS = ADC_MUXPOS_AIN7_gc;
    ADC0.COMMAND = 0x1;
}

void vINDTimerFunc( TimerHandle_t xTimer )
{
    xINDTimerSet = 1;
}

void vCircCheckTimerFunc( TimerHandle_t xTimer )
{
    xSTATTimerSet = 1;
}
void vBattCheckTimerFunc( TimerHandle_t xTimer )
{
    xBATTTimerSet = 1;
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

ISR(ADC0_RESRDY_vect)
{
    volatile uint16_t res[1];
    res[0] = ADC0.RES; //this should also clear the interrupt flag
    ADC0.MUXPOS = ADC_MUXPOS_GND_gc;
    xQueueSendToBackFromISR(xSTAT_Queue, res, NULL);
}