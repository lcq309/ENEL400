/* 
 * File:   DSIO.h
 * Author: Michael King
 * Device Specific I/O for the generic wired sector controller
 * this file needs to define the RS485TR, as well as indicators and button interrupts
 * and I/O handling tasks.
 * Created on July 7, 2024
 */

#define USARTBAUD 57600 //redefine BAUD for the wireless network

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
    
    //Semaphores
    
    extern SemaphoreHandle_t xNotify; //defined in the communications module
    
    //timer globals
    
    extern uint8_t xINDTimerSet;
    extern uint8_t xBATTTimerSet;
    
    //timer handles
    
    extern TimerHandle_t xINDTimer;
    extern TimerHandle_t xBATTTimer;
    
    //Stat semaphore
    
    extern SemaphoreHandle_t xBattCheckTrig; //manual circuit check trigger
    
    //queue handles

    extern QueueHandle_t xPB_Queue;
    extern QueueHandle_t xIND_Queue;
    extern QueueHandle_t xDeviceIN_Queue;
    extern QueueHandle_t xSTAT_Queue;
    
    //Event Groups
    extern EventGroupHandle_t xEventInit;

    //Task Definition
    void dsIOInTask ( void * parameters );
    void dsIOOutTask ( void * parameters );
    void dsIOSTATUS ( void * parameters );
    
    //task setup function
    void DSIOSetup(void);
    
    //voltage check function
    void VoltageCheck(void);
    
    //timer callback functions
    void vINDTimerFunc( TimerHandle_t xTimer ); 
    void vBattCheckTimerFunc( TimerHandle_t xTimer );
    
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
    
    void dsioStatOn(void);
    void dsioStatOff(void);
    void dsioStatTGL(void);
    
#ifdef	__cplusplus
}
#endif

#endif	/* DSIO_H */

