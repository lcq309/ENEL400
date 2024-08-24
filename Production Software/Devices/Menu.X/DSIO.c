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
    QueueHandle_t xDeviceIN_Queue;
    
    //stream buffer

    StreamBufferHandle_t xNEXTION_out_Buffer;
    StreamBufferHandle_t xNEXTION_in_Buffer;
    
    //message buffers
    
    MessageBufferHandle_t xIND_Buffer;
    
    //Semaphore
    
    SemaphoreHandle_t xNEXTION_Sem;
    
void DSIOSetup()
{
    //USART_init
    USART1_init();
    USART1.CTRLC = USART_CMODE_ASYNCHRONOUS_gc | USART_CHSIZE_8BIT_gc | \
            USART_PMODE_DISABLED_gc; //disable parity for Nextion
    
    //setup Queues
    
    xPB_Queue = xQueueCreate(2, 2 * sizeof(uint8_t)); //up to 2 touchscreen messages held
    xDeviceIN_Queue = xQueueCreate(3, 3 * sizeof(uint8_t)); // intertask messages to the device specific task
    
    //setup stream buffers
    
    xIND_Buffer = xMessageBufferCreate(50);
    xNEXTION_out_Buffer = xStreamBufferCreate(40,1); //40 bytes, triggers when a byte is added
    xNEXTION_in_Buffer = xStreamBufferCreate(40,1);
    
    //setup tasks
    
    xTaskCreate(dsIOInTask, "PBIN", 250, NULL, mainPBIN_TASK_PRIORITY, NULL);
    xTaskCreate(dsIOOutTask, "INDOUT", 250, NULL, mainINDOUT_TASK_PRIORITY, NULL);
    xTaskCreate(NextionInTask, "NEXT", 250, NULL, mainNEXT_TASK_PRIORITY, NULL);
    
    //setup timers
    xINDTimer = xTimerCreate("INDT", 250, pdTRUE, 0, vINDTimerFunc);
    
    //start the indicator timer
    xTimerStart(xINDTimer, 0);
}

void NextionInTask (void * parameters)
{
    uint8_t message_buffer[2];
    uint8_t byte_buffer[1];
    uint8_t length = 0; //message length from header
    //wait for initialization
    xEventGroupWaitBits(xEventInit, 0x1, pdFALSE, pdFALSE, portMAX_DELAY);
    for(;;)
    {
        uint8_t received = 0;
        message_buffer[0] = 0;
        message_buffer[1] = 0;
        //wait for something to appear on the bus
        if(xStreamBufferReceive(xNEXTION_in_Buffer, byte_buffer, 1, portMAX_DELAY) != 0)
        {
            if(byte_buffer[0] == 0x7e)
            {
                length = 2;
            }
            else
                length = 0; //just ignore this message, something went wrong
            
            for(uint8_t i = 0; i < length; i++)
            {
                //assemble the message byte by byte until the length is reached
                if(xStreamBufferReceive(xNEXTION_in_Buffer, byte_buffer, 1, 10) != 0)
                    message_buffer[i] = byte_buffer[0];
                //if nothing is received, cancel message receipt. Something went wrong
                else
                    length = 0;
                //this if/else statement constitutes collision recovery code.
                //if a collision occurs and breaks the loop, the timeout will save us from getting trapped here.
            }
            xQueueSendToFront(xPB_Queue, message_buffer, portMAX_DELAY);
        }
        else
            byte_buffer[0] = 0x0;
    }
}

void dsIOInTask (void * parameters)
{
    //initialization complete, enter looping section.
    uint8_t input[2];
    uint8_t output[3] = {'P', 0, 0}; //P for pushbutton in intertask messages
    for(;;)
    {
        //wait for input
        xQueueReceive(xPB_Queue, input, portMAX_DELAY);
        output[1] = input[0];
        output[2] = input[1];
        xQueueSendToBack(xDeviceIN_Queue, output, portMAX_DELAY);
        xSemaphoreGive(xNotify);
    }
    
}

void dsIOOutTask (void * parameters)
{
    //receiver buffer
    uint8_t received[50];
    uint8_t EndDelimiter[3] = {0xff,0xff,0xff};
    uint8_t size = 0;
    
    //running loop
    for(;;)
    {
        //first, check for commands from other tasks (hold for 50ms)
        size = xMessageBufferReceive(xIND_Buffer, received, 50, 50);
        if(size != 0)
        {
            //load the command into the output buffer, then load the end delimiter
            xStreamBufferSend(xNEXTION_out_Buffer, received, size, 0);
            xStreamBufferSend(xNEXTION_out_Buffer, EndDelimiter, 3, 0);
            //start the transmission
            USART1.CTRLA |= USART_DREIE_bm;
            //wait for end of transmission
            xSemaphoreTake(xNEXTION_Sem, portMAX_DELAY);
        }
        
    }
                vTaskSuspend(NULL);
    
}

//timer callback functions

void vINDTimerFunc( TimerHandle_t xTimer )
{
    xINDTimerSet = 1;
}

//interrupts go here

ISR(USART1_RXC_vect)
{
    /* Receive complete interrupt
     * move received byte into byte buffer for RS485 in task
     */
    uint8_t buf[1];
    buf[0] = USART1.RXDATAL;
    xStreamBufferSendFromISR(xNEXTION_in_Buffer, buf, 1, NULL);
}
ISR(USART1_DRE_vect)
{
    /* Data Register empty Interrupt
     * 1. pull from output stream buffer and put in TX register until clear
     * 2. disable interrupt
     */
    uint8_t buf[1];
    if(xStreamBufferReceiveFromISR(xNEXTION_out_Buffer, buf, 1, NULL) == 0) //if end of message
        USART1.CTRLA &= ~USART_DREIE_bm; //disable interrupt
    else
        USART1.TXDATAL = buf[0];
}
ISR(USART1_TXC_vect)
{
    /* Transmission complete interrupts
     * 1. set semaphore
     * 2. clear interrupt flag
     */
    USART1.STATUS |= USART_TXCIF_bm; //clear flag by writing a 1 to it
    xSemaphoreGiveFromISR(xNEXTION_Sem, NULL); //send notification to output task
}