/* 
 * File:   DSIO.h
 * Author: Michael King
 * Device Specific I/O for the generic wired sector controller
 * this file needs to define the RS485TR, as well as indicators and button interrupts
 * and I/O handling tasks.
 * Created on April 23, 2024
 */

#include <avr/io.h>
#include <avr/interrupt.h>
#include "FreeRTOS.h"
#include "task.h"
#include "semphr.h"
#include "event_groups.h"
#include "queue.h"
#include "timers.h"
#include "I2C.h"
#include "stream_buffer.h"
#include "message_buffer.h"

#ifndef DSIO_H
#define	DSIO_H

#ifdef	__cplusplus
extern "C" {
#endif

#define mainPBIN_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainINDOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainNEXT_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
    
    //Semaphores
    
    extern SemaphoreHandle_t xNotify; //defined in the communications module
    extern SemaphoreHandle_t xNEXTION_Sem;
    
    //timer globals
    
    extern uint8_t xINDTimerSet;
    
    //timer handles
    
    extern TimerHandle_t xINDTimer;
    
    //queue handles

    extern QueueHandle_t xPB_Queue;
    extern QueueHandle_t xDeviceIN_Queue;
    
    //stream handle
    
    extern MessageBufferHandle_t xIND_Buffer;
    extern StreamBufferHandle_t xNEXTION_out_Buffer;
    extern StreamBufferHandle_t xNEXTION_in_Buffer;
    
    //Event Groups
    extern EventGroupHandle_t xEventInit;

    //Task Definition
    void dsIOInTask ( void * parameters );
    void dsIOOutTask ( void * parameters );
    void NextionInTask ( void * parameters );
    
    //task setup function
    void DSIOSetup(void);
    
    //timer callback functions
    void vINDTimerFunc( TimerHandle_t xTimer );
    void vPBTimerFunc( TimerHandle_t xTimer );
    
#ifdef	__cplusplus
}
#endif

#endif	/* DSIO_H */

