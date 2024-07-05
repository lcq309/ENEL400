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
    
    //stream buffer

    StreamBufferHandle_t xI2C_out_Buffer;
    
void DSIOSetup()
{
    //485 R/W pin setup
    PORTD.DIRSET = PIN7_bm;
    PORTD.OUTCLR = PIN7_bm;
    
    //I2C setup
    I2C_init();
    
    //setup Queues
    
    xPB_Queue = xQueueCreate(1, sizeof(uint8_t)); //up to 1 button presses held
    xIND_Queue = xQueueCreate(4, 3 * sizeof(uint8_t)); // up to 4 Indicator Commands held
    xDeviceIN_Queue = xQueueCreate(3, 2 * sizeof(uint8_t)); // intertask messages to the device specific task
    
    //setup stream buffer
    
    xI2C_out_Buffer = xStreamBufferCreate(20,1); //20 bytes, triggers when a byte is added
    
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
    PORTD.DIRCLR = PIN6_bm | PIN5_bm | PIN3_bm | PIN2_bm;
    PORTC.DIRCLR = PIN3_bm;
    //Then I will set up the multi-configure register for port D.
    PORTD.PINCONFIG = 0x3 | PORT_PULLUPEN_bm; //enable falling edge interrupt and pullup
    //update configuration for selected pins
    PORTD.PINCTRLUPD = PIN6_bm | PIN5_bm | PIN3_bm | PIN2_bm;
    // single pin configuration for PORT C
    PORTC.PIN3CTRL |= PORT_PULLUPEN_bm | 0x3;
            
    //for now, this just reads button presses with a half second debounce delay to avoid spam.
    //block until a button press occurs, then check anti spam timer and reset timer
    //initialization complete, enter looping section.
    uint8_t input[1];
    uint8_t output[2] = {'P', 0}; //P for pushbutton in intertask messages
    for(;;)
    {
        //wait for input
        xQueueReceive(xPB_Queue, input, portMAX_DELAY);
        output[1] = input[0];
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
    
    //digit state buffer initialized to zero.
    static uint8_t DigitOne = 0;
    static uint8_t DigitTwo = 0;
    static uint8_t displaytype = 0; //flashing, solid, off
    uint8_t state = 0; //for flashing
    
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
        if(xQueueReceive(xIND_Queue, received, 20) == pdTRUE)
        {
            //set the digits and mode
            received[0] = DigitOne;
            received[1] = DigitTwo;
            received[2] = displaytype;
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
                //first and last digit is always left blank
                digit = I2C_translate(DigitOne);
                output[3] = digit & 0xff;
                output[4] = (digit >> 8) & 0xff;
                digit = I2C_translate(DigitTwo);
                output[5] = digit & 0xff;
                output[6] = (digit >> 8) & 0xff;
                xStreamBufferSend(xI2C_out_Buffer, output, 9, 10);
                //with the message loaded, load the address buffer with the address for the display
                TWI0.MADDR = 0x70;
                //start message sending by enabling the interrupt
                TWI0.MCTRLA |= TWI_WIEN_bm;
                break;
                
            case 0: //off
                for(uint8_t i = 0; i < 9; i++)
                {
                    output[i] = 0;
                }
                xStreamBufferSend(xI2C_out_Buffer, output, 9, 10);
                //with the message loaded, load the address buffer with the address for the display
                TWI0.MADDR = 0x70;
                //start message sending by enabling the interrupt
                TWI0.MCTRLA |= TWI_WIEN_bm;
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
            pb[0] = 'U'; //up
            break;
        case PIN5_bm: //button 2
            PORTD.INTFLAGS = PIN5_bm; //reset interrupt
            pb[0] = 'D'; //down
            break;
        case PIN3_bm: //button 3
            PORTD.INTFLAGS = PIN3_bm; //reset interrupt
            pb[0] = 'H'; //halfway
            break;
        case PIN2_bm: //button 4
            PORTD.INTFLAGS = PIN2_bm;
            pb[0] = 'Z'; //zero
    }
    xQueueSendToBackFromISR(xPB_Queue, pb, NULL);
}

ISR(PORTC_PORT_vect)
{
    uint8_t pb[1] = {0};
    switch(PORTC.INTFLAGS)
    {
        case PIN3_bm: //button 1
            PORTC.INTFLAGS = PIN3_bm; //reset interrupt
            pb[0] = 'L'; //last
            break;
    }
    xQueueSendToBackFromISR(xPB_Queue, pb, NULL);
}

ISR(TWI0_TWIM_vect)
{
    uint8_t byte[1] = {0};
    if(TWI0.MSTATUS & TWI_WIF_bm) //if this is the write interrupt
    {
        if(xStreamBufferReceiveFromISR(xI2C_out_Buffer, byte, 1, NULL) != 0)
        {
            //if something was in the buffer
            TWI0.MDATA = byte[0];
        }
        else
        {
            //disable the interrupt
            TWI0.MCTRLA &= ~TWI_WIEN_bm;
            //after sending the message, send a STOP over the bus by writing to MCMD field
            TWI0.MCTRLB |= TWI_MCMD_STOP_gc;
        }
    }
}