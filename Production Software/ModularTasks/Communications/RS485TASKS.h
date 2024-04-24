/* 
 * File:   RS485TASKS.h
 * Author: Michael King
 * Header file that defines the RS485 IN/OUT tasks for devices on the wired network
 * as well as a small function to set them up, to be called before the scheduler starts or during initialization.
 * The tasks are included in the .c
 * Created on April 22, 2024
 */

#include <avr/io.h>
#include <avr/interrupt.h>
#include "FreeRTOS.h"
#include "task.h"
#include "semphr.h"
#include "event_groups.h"
#include "stream_buffer.h"
#include "message_buffer.h"
#include "DSIO.h"
#include "USART.h"

#ifndef RS485TASKS_H
#define	RS485TASKS_H

#ifdef	__cplusplus
extern "C" {
#endif

    #define MAX_MESSAGE_SIZE 200
    #define DEVICE_TABLE_SIZE 250
    //default priorities (can be redefined in device specific task)
    #define mainCOMMOUT_TASK_PRIORITY (tskIDLE_PRIORITY + 3)
    #define mainCOMMIN_TASK_PRIORITY (tskIDLE_PRIORITY + 4)
    
    static uint8_t GLOBAL_TableLength = 0; //increments as new entries are added to the table

    struct Device {
    uint8_t XBeeADD[8];
    uint8_t WiredADD;
    uint8_t Channel;
    uint8_t Type;
};

    static struct Device GLOBAL_DEVICE_TABLE[DEVICE_TABLE_SIZE]; //create device table
    
    //External Globals
    extern uint8_t GLOBAL_DeviceID;
    extern uint8_t GLOBAL_Channel;
    extern uint8_t GLOBAL_DeviceType;
    
    //MUTEXes
    
    static SemaphoreHandle_t xUSART0_MUTEX = NULL;
    
    //Semaphores
    static SemaphoreHandle_t xPermission = NULL; //task notification replacement
    static SemaphoreHandle_t xTXC = NULL;
    
    //Event Groups
    static EventGroupHandle_t xEventInit = NULL;
    
    //stream handles (note device buffer is externally defined in device specific)

    static StreamBufferHandle_t xCOMM_in_Stream = NULL;
    static StreamBufferHandle_t xCOMM_out_Stream = NULL;
    static MessageBufferHandle_t xCOMM_out_Buffer = NULL;
    extern MessageBufferHandle_t xDevice_Buffer = NULL;
    
    //task definition
    static void modCOMMOutTask ( void *parameters );
    static void modCOMMInTask ( void *parameters );
    
    //task setup function
    void COMMSetup(void);
    
    //transceiver in/out set function ('R' for receive, 'T' for transmit)
    //defined in device specific I/O.h
    extern void RS485TR(uint8_t dir);
    
#ifdef	__cplusplus
}
#endif

#endif	/* RS485TASKS_H */

