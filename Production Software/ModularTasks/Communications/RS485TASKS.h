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
#include "timers.h"
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
    
    extern uint8_t GLOBAL_TableLength; //increments as new entries are added to the table
    extern uint8_t GLOBAL_NetNum; //track number of networks
    extern uint8_t GLOBAL_MessageSent; //track whether or not a message has been sent yet to avoid loading the buffer with repeat transmissions
    
    struct Device {
    uint8_t XBeeADD[8];
    uint8_t WiredADD;
    uint8_t Channel;
    uint8_t Type;
    uint8_t Net; //net number for internal tracking of different wired networks
};

    extern struct Device GLOBAL_DEVICE_TABLE[DEVICE_TABLE_SIZE]; //create device table
    
    //External Globals
    
    extern uint8_t GLOBAL_DeviceID;
    extern uint8_t GLOBAL_Channel;
    extern uint8_t GLOBAL_DeviceType;
    
    //MUTEXes
    
    extern SemaphoreHandle_t xUSART0_MUTEX;
    
    //Semaphores
    extern SemaphoreHandle_t xPermission; //task notification replacement
    extern SemaphoreHandle_t xTXC;
    extern SemaphoreHandle_t xNotify;
    
    //Event Groups
    extern EventGroupHandle_t xEventInit;
    
    //stream handles

    extern StreamBufferHandle_t xCOMM_in_Stream;
    extern StreamBufferHandle_t xCOMM_out_Stream;
    extern MessageBufferHandle_t xCOMM_out_Buffer;
    extern MessageBufferHandle_t xDevice_Buffer;
    
    //Queues
    
    extern QueueHandle_t xDeviceIN_Queue;
    
    //timer handles
    
    extern TimerHandle_t xOFFSETTimer;
    extern TimerHandle_t xPeriodicJoinTimer;
    
    //task definition
    void modCOMMOutTask ( void *parameters );
    void modCOMMInTask ( void *parameters );
    
    //timer functions;
    void vOFFSETTimerFunc( TimerHandle_t xTimer );
    void vPeriodicJoinTimerFunc( TimerHandle_t xTimer );
    
    //task setup function
    void COMMSetup(void);
    
    //transceiver in/out set function ('R' for receive, 'T' for transmit)
    //defined in device specific I/O.h
    extern void RS485TR(uint8_t dir);
    
#ifdef	__cplusplus
}
#endif

#endif	/* RS485TASKS_H */

