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
    
    uint8_t xINDTimerSet = 0;
    uint8_t xBATTTimerSet;
    
    //timer handles
    
    TimerHandle_t xINDTimer;
    TimerHandle_t xBATTTimer;
    
    
    //Semaphores
    
    SemaphoreHandle_t xBattCheckTrig;
    
    //queue handles

    QueueHandle_t xPB_Queue;
    QueueHandle_t xIND_Queue;
    QueueHandle_t xDeviceIN_Queue;
    QueueHandle_t xSTAT_Queue;
    
void DSIOSetup()
{
    //Indicator pin setup
    PORTC.DIRSET = PIN0_bm | PIN3_bm;
    PORTD.DIRSET = PIN1_bm | PIN3_bm;
    
    //prepare ADC
    ADC_init();
    
    //setup Queues
    xPB_Queue = xQueueCreate(1, sizeof(uint8_t)); //up to 1 button presses held
    xIND_Queue = xQueueCreate(4, 2 * sizeof(uint8_t)); // up to 4 Indicator Commands held
    xDeviceIN_Queue = xQueueCreate(3, 2 * sizeof(uint8_t)); // intertask messages to the device specific task
    xSTAT_Queue = xQueueCreate(1, 1 * sizeof(uint16_t)); // messages from RESRDY
    
    //setup tasks
    
    xTaskCreate(dsIOInTask, "PBIN", 250, NULL, mainPBIN_TASK_PRIORITY, NULL);
    xTaskCreate(dsIOOutTask, "INDOUT", 250, NULL, mainINDOUT_TASK_PRIORITY, NULL);
    xTaskCreate(dsIOSTATUS, "STAT", 150, NULL, mainSTAT_TASK_PRIORITY, NULL);
    
    //setup timers
    xINDTimer = xTimerCreate("INDT", 50, pdTRUE, 0, vINDTimerFunc);
    xBATTTimer = xTimerCreate("STAT", 500, pdFALSE, 0, vBattCheckTimerFunc);
    
    //setup the semaphore
    xBattCheckTrig = xSemaphoreCreateBinary();
    
    //start the indicator timer
    xTimerStart(xINDTimer, 0);
}

void dsIOInTask (void * parameters)
{
    //initialize inputs
    PORTD.DIRCLR = PIN6_bm | PIN5_bm | PIN4_bm;
    //Then I will set up the multi-configure register for port D.
    PORTD.PINCONFIG = 0x3 | PORT_PULLUPEN_bm; //enable falling edge interrupt and pullup
    //update configuration for selected pins
    PORTD.PINCTRLUPD = PIN6_bm | PIN5_bm | PIN4_bm;
    //block until a button press occurs, then check anti spam timer and reset timer
    //initialization complete, enter looping section.
    uint8_t input[1];
    uint8_t output[2] = {'P', 0}; //P for pushbutton in intertask messages
    for(;;)
    {
        //wait for input
        xQueueReceive(xPB_Queue, input, portMAX_DELAY);
        output[1] = input[0];
        if(input[0] == 'Y') //if yellow, send to front
            xQueueSendToFront(xDeviceIN_Queue, output, portMAX_DELAY);
        else
            xQueueSendToBack(xDeviceIN_Queue, output, portMAX_DELAY);
        xSemaphoreGive(xNotify);
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
    static uint8_t STAT = 0;
    
    //time buffers for flash and latches
    static uint8_t flash = 0; 
    static uint8_t blink = 0; 
    static uint8_t ms250 = 0;
    
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
            case 'G': //Green indicator
                GREEN = received[1];
                break;
            case 'Y': //Yellow indicator
                YELLOW = received[1];
                break;
            case 'B': //Blue indicator
                BLUE = received[1];
                break;
            case 'S': //Stat indicator
                STAT = received[1];
                break;
                
            case 0xff: //All indicators
                STAT = received[1];
            case 0xfe: //All indicators except stat
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
            
            case 'D': //double flash
                if(flash == 0)
                {
                    dsioGreenOn();
                    vTaskDelay(5);
                    dsioGreenTGL();
                    vTaskDelay(5);
                    dsioGreenTGL();
                    vTaskDelay(5);
                    dsioGreenOff();
                }
                break;
                
            case 'W': //warning flash (used for lockout warning)
                dsioGreenOn();
                vTaskDelay(5);
                dsioGreenTGL();
                vTaskDelay(5);
                dsioGreenTGL();
                vTaskDelay(5);
                dsioGreenTGL();
                vTaskDelay(5);
                dsioGreenTGL();
                vTaskDelay(5);
                dsioGreenTGL();
                vTaskDelay(5);
                dsioGreenTGL();
                vTaskDelay(5);
                dsioGreenOff();
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
            
            case 'D': //double flash
                if(flash == 0)
                {
                    dsioBlueOn();
                    vTaskDelay(5);
                    dsioBlueTGL();
                    vTaskDelay(5);
                    dsioBlueTGL();
                    vTaskDelay(5);
                    dsioBlueOff();
                }
                break;
                
            case 'W': //warning flash (used for lockout warning)
                dsioBlueOn();
                vTaskDelay(5);
                dsioBlueTGL();
                vTaskDelay(5);
                dsioBlueTGL();
                vTaskDelay(5);
                dsioBlueTGL();
                vTaskDelay(5);
                dsioBlueTGL();
                vTaskDelay(5);
                dsioBlueTGL();
                vTaskDelay(5);
                dsioBlueTGL();
                vTaskDelay(5);
                dsioBlueOff();
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
            
            case 'D': //double flash
                if(flash == 0)
                {
                    dsioYellowOn();
                    vTaskDelay(5);
                    dsioYellowTGL();
                    vTaskDelay(5);
                    dsioYellowTGL();
                    vTaskDelay(5);
                    dsioYellowOff();
                }
                break;
            
            case 'W': //warning flash (used for lockout warning)
                dsioYellowOn();
                vTaskDelay(5);
                dsioYellowTGL();
                vTaskDelay(5);
                dsioYellowTGL();
                vTaskDelay(5);
                dsioYellowTGL();
                vTaskDelay(5);
                dsioYellowTGL();
                vTaskDelay(5);
                dsioYellowTGL();
                vTaskDelay(5);
                dsioYellowTGL();
                vTaskDelay(5);
                dsioYellowOff();
                break;
                
            case 'S': //solid
                dsioYellowOn();
            break;
            
            case 'O': //off
                dsioYellowOff();
            break;
        }
        //process stat
        switch(STAT)
        {
            case 'B': //blink
                if(blink == 0 && ms250 == 0)
                    dsioStatTGL();
                break;

            case 'F': //flash
                if(flash == 0)
                    dsioStatTGL();
                break;

            case 'D': //double flash
                if(flash == 0)
                {
                    dsioStatOn();
                    vTaskDelay(5);
                    dsioStatTGL();
                    vTaskDelay(5);
                    dsioStatTGL();
                    vTaskDelay(5);
                    dsioStatOff();
                }
                break;

            case 'W': //warning flash (used for lockout warning)
                dsioStatOn();
                vTaskDelay(5);
                dsioStatTGL();
                vTaskDelay(5);
                dsioStatTGL();
                vTaskDelay(5);
                dsioStatTGL();
                vTaskDelay(5);
                dsioStatTGL();
                vTaskDelay(5);
                dsioStatTGL();
                vTaskDelay(5);
                dsioStatTGL();
                vTaskDelay(5);
                dsioStatOff();
                break;

            case 'S': //solid
                dsioStatOn();
                break;

            case 'O': //off
                dsioStatOff();
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
        uint8_t outbuffer[2] = {'S', 'B'};
        volatile uint16_t received[1];
        //block on manual trigger semaphore
        if(xSemaphoreTake(xBattCheckTrig, 50) == pdTRUE)
        {
            //check the battery voltage
            VoltageCheck();
            xBATTTimerSet = 0;
            xTimerReset(xBATTTimer, 0);
            //wait for result before moving on
            xQueueReceive(xSTAT_Queue, received, portMAX_DELAY); //check output after starting the sample, but before blocking
            //check against reference value of 2402 (~1.935V over resistor)
            if(received[0] < 2402)
            {
                //low battery state, send the message to the main task
                xQueueSendToBack(xDeviceIN_Queue, outbuffer, 10);
            }
        }
        else //if not a manual trigger, then check timer and do the periodic if the time is right
        {
            if(xBATTTimerSet == 1)
            {
                //check the battery voltage
                VoltageCheck();
                xBATTTimerSet = 0;
                xTimerReset(xBATTTimer, 0);
                //wait for result before moving on
                xQueueReceive(xSTAT_Queue, received, portMAX_DELAY); //check output after starting the sample, but before blocking
                //check against reference value of 2402 (~1.935V over resistor)
                if(received[0] < 2402)
                {
                    //low battery state, send the message to the main task
                    xQueueSendToBack(xDeviceIN_Queue, outbuffer, 10);
                }
            }
        }
    }
}

void VoltageCheck(void)
{
    ADC0.MUXPOS = ADC_MUXPOS_AIN7_gc;
    ADC0.COMMAND = 0x1;
}

//timer callback functions

void vINDTimerFunc( TimerHandle_t xTimer )
{
    xINDTimerSet = 1;
}
void vBattCheckTimerFunc( TimerHandle_t xTimer )
{
    xBATTTimerSet = 1;
}

void dsioGreenOn(void)
{
    PORTD.OUTSET = PIN3_bm;
}
void dsioGreenOff(void)
{
    PORTD.OUTCLR = PIN3_bm;
}
void dsioGreenTGL(void)
{
    PORTD.OUTTGL = PIN3_bm;
}
    
void dsioYellowOn(void)
{
    PORTC.OUTSET = PIN3_bm;
}
void dsioYellowOff(void)
{
    PORTC.OUTCLR = PIN3_bm;
}
void dsioYellowTGL(void)
{
    PORTC.OUTTGL = PIN3_bm;
}
    
void dsioBlueOn(void)
{
    PORTD.OUTSET = PIN1_bm;
}
void dsioBlueOff(void)
{
    PORTD.OUTCLR = PIN1_bm;
}
void dsioBlueTGL(void)
{
    PORTD.OUTTGL = PIN1_bm;
}

void dsioStatOn(void)
{
    PORTC.OUTSET = PIN0_bm;
}
void dsioStatOff(void)
{
    PORTC.OUTCLR = PIN0_bm;
}
void dsioStatTGL(void)
{
    PORTC.DIRTGL = PIN0_bm;
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
        case PIN6_bm: //Yellow button
            PORTD.INTFLAGS = PIN6_bm; //reset interrupt
            pb[0] = 'Y';
            break;
        case PIN5_bm: //Blue Button
            PORTD.INTFLAGS = PIN5_bm; //reset interrupt
            pb[0] = 'B';
            break;
        case PIN4_bm: //Green Button
            PORTD.INTFLAGS = PIN4_bm; //reset interrupt
            pb[0] = 'G';
            break;
    }
    xQueueSendToBackFromISR(xPB_Queue, pb, NULL);
}

ISR(ADC0_RESRDY_vect)
{
    volatile uint16_t res[1];
    res[0] = ADC0.RES; //this should also clear the interrupt flag
    ADC0.MUXPOS = ADC_MUXPOS_GND_gc;
    xQueueSendToBackFromISR(xSTAT_Queue, res, NULL);
}