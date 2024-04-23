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
#include "stream_buffer.h"
#include "message_buffer.h"

#ifndef DSIO_H
#define	DSIO_H

#ifdef	__cplusplus
extern "C" {
#endif

#define mainPBIN_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
#define mainINDOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 2)
    
    //queue handles

    static QueueHandle_t xPB_Queue = NULL;
    static QueueHandle_t xIND_Queue = NULL;
    static QueueHandle_t xDeviceIN_Queue = NULL;
    
    //Event Groups
    extern EventGroupHandle_t xEventInit = NULL;

    //Task Definition
    static void dsIOInTask ( void * parameters );
    static void dsIOOutTask ( void * parameters );
    
    //task setup function
    void DSIOSetup(void);

    /* RS 485 TR
     * Transceiver control function for transmit or receive.
     * 'T' should set the transceiver, 'R' should set the receiver.
     */
    void RS485TR(uint8_t dir);
    
#ifdef	__cplusplus
}
#endif

#endif	/* DSIO_H */

