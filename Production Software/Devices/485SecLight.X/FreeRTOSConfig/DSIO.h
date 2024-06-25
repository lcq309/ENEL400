/* 
 * File:   DSIO.h
 * Author: Michael King
 * Device Specific I/O for the generic wired sector light
 * this file needs to define the RS485TR, as well as indicators and button interrupts
 * and I/O handling tasks. This code also needs to define the error checking routines
 * Created on April 23, 2024
 */

#include <stdio.h>
#include <stdlib.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include "FreeRTOS.h"
#include "task.h"
#include "semphr.h"
#include "event_groups.h"
#include "timers.h"
#include "ADC.h"

#ifndef DSIO_H
#define	DSIO_H

#ifdef	__cplusplus
extern "C" {
#endif

#define mainPBIN_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainINDOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainSTAT_TASK_PRIORITY (tskIDLE_PRIORITY + 3)
    
    //timer globals
    
    extern uint8_t xINDTimerSet;
    
    //timer handles
    
    extern TimerHandle_t xINDTimer;
    
    //queue handles

    extern QueueHandle_t xIND_Queue;
    extern QueueHandle_t xDeviceIN_Queue;
    extern QueueHandle_t xSTAT_Queue;
    
    //Event Groups
    extern EventGroupHandle_t xEventInit;

    //Task Definition
    void dsIOOutTask ( void * parameters );
    
    void dsIOSTATUS ( void * parameters );
    
    //task setup function
    void DSIOSetup(void);
    
    //timer callback functions
    void vINDTimerFunc( TimerHandle_t xTimer ); 
    
    /* Current sense request
     * Starts the process of sampling the current sense resistor
     */
    void LightCheck(void);
    
    /* RS 485 TR
     * Transceiver control function for transmit or receive.
     * 'T' should set the transceiver, 'R' should set the receiver.
     */
    void RS485TR(uint8_t dir);
    
    /* output indicator functions
     * functions to toggle, turn on, or turn off the output indicators
     */
    void dsioGreenOn(void);
    void dsioGreenOff(void);
    void dsioGreenTGL(void);
    
    void dsioYellowOn(void);
    void dsioYellowOff(void);
    void dsioYellowTGL(void);
    
    void dsioBlueOn(void);
    void dsioBlueOff(void);
    void dsioBlueTGL(void);
    
    void dsioRedOn(void);
    void dsioRedOff(void);
    void dsioRedTGL(void);
    
#ifdef	__cplusplus
}
#endif

#endif	/* DSIO_H */

