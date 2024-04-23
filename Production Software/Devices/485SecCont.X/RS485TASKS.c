/* 
 * File:   RS485TASKS.c
 * Author: Michael King
 * c file that includes the RS485 IN/OUT tasks for devices on the wired network
 * as well as a small function to set them up, to be called before the scheduler starts or during initialization.
 * Created on April 22, 2024
 */

#include "RS485TASKS.h"

void COMMSetup()
{
    //setup MUTEX
    
    xUSART0_MUTEX = xSemaphoreCreateMutex();
    
    //setup buffers
    
    xCOMM_in_Stream = xStreamBufferCreate(50,1); //50 bytes, triggers when a byte is added
    xCOMM_out_Stream = xStreamBufferCreate(2 * MAX_MESSAGE_SIZE, 1); //output buffer
    xCOMM_out_Buffer = xMessageBufferCreate(MAX_MESSAGE_SIZE);
    
    //setup semaphore
    
    xPermission = xSemaphoreCreateBinary();
    xTXC = xSemaphoreCreateBinary();
    
    //setup event group
    
    xEventInit = xEventGroupCreate();
    
    //setup tasks 
    
    xTaskCreate(modCOMMOutTask, "COMMOUT", (MAX_MESSAGE_SIZE + 300), NULL, mainCOMMOUT_TASK_PRIORITY, NULL);
    xTaskCreate(modCOMMInTask, "COMMIN", 400, NULL, mainCOMMIN_TASK_PRIORITY, NULL);
}

static void modCOMMOutTask (void * parameters)
{
    /* RS 485 out handling
     * wait for initialization to complete
     * loop:
     * 1. generate message destination header from pointed index entry
     * 2. load header into output stream
     * 3. load message into output stream
     * permission to transmit:
     * grab USART mutex
     * once output buffer is empty:
     * 1. generate ping response
     * 2. send PR
     * 3. wait for TXC
     * 4. release USART mutex
     * set TX mode
     * clear output buffer by setting DREIE (needs testing to determine if output buffer needs to be pre-fed to trigger interrupt)
     * DREI is disabled by the TXC Interrupt
     * release USART mutex
     */
    uint8_t buffer[MAX_MESSAGE_SIZE];
    uint8_t header_buffer[14];
    uint8_t length = 0;
    uint8_t size = 0;
    uint8_t PR[4] = {0x7e, 2, 'R', GLOBAL_DeviceID};
    uint8_t netmessage[14] = {0x7e, 12, 'O', GLOBAL_DeviceID, GLOBAL_Channel, GLOBAL_DeviceType, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xFF, 0xFF};
    // header and message bits
    xEventGroupWaitBits(xEventInit, 0x1, pdFALSE, pdFALSE, portMAX_DELAY); // wait for init
    
    for(;;) //begin main loop
    {
    //loop through messages, stop looping when out of messages to send.
    do {
        size = xMessageBufferReceive(xRS485_out_Buffer, buffer, MAX_MESSAGE_SIZE, 0);
        //check index
        if((buffer[0] == 0xff) && (size != 0)) //if network generation message requested, load the join message into the output stream
        {
            //load join message into output
            xStreamBufferSend(xCOMM_out_Stream, netmessage, 14, portMAX_DELAY);
        }
        else if(size != 0) //generate header based on the information at the index, and load into the output stream with the message
        {
            //end of message contains the index of the target device.
            //reduce length by one, since we won't be sending the index value
            length = size - 1;
            length = length + 12; //add header to length
            header_buffer[0] = 0x7e; //start delimiter
            header_buffer[1] = length; //length byte
            header_buffer[2] = 'O'; //outgoing
            header_buffer[3] = GLOBAL_DeviceID; //sender device ID
            header_buffer[4] = GLOBAL_Channel; //device channel
            header_buffer[5] = GLOBAL_DeviceType; //sender device type
            header_buffer[6] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].XBeeADD[0];
            header_buffer[7] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].XBeeADD[1];
            header_buffer[8] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].XBeeADD[2];
            header_buffer[9] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].XBeeADD[3];
            header_buffer[10] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].XBeeADD[4];
            header_buffer[11] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].XBeeADD[5];
            header_buffer[12] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].XBeeADD[6];
            header_buffer[13] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].XBeeADD[7];
            //load output header
            xStreamBufferSend(xCOMM_out_Stream, header_buffer, 14, portMAX_DELAY);
            //load output message
            xStreamBufferSend(xCOMM_out_Stream, header_buffer, size - 1, portMAX_DELAY);
        }
        } while(length != 0);
    // wait for notification (if not received then just go back to the start of the loop)
    if(xSemaphoreTake(xPermission, 500) == pdTRUE)
    {
    // acquire hardware mutex
    xSemaphoreTake(xUSART0_MUTEX, portMAX_DELAY);
    // load the ping response
    xStreamBufferSend(xCOMM_out_Stream, PR, 4, portMAX_DELAY);
    // set transceiver to transmit mod
    RS485TR('T');
    //enable DRE interrupt
    USART0.CTRLA |= USART_DREIE_bm;
    //wait for TXcomplete notification
    xSemaphoreTake(xTXC, portMAX_DELAY);
    //release USART MUTEX
    xSemaphoreGive(xUSART0_MUTEX);
    //end of message, wait until permission given again
    }
    }
}

static void modCOMMInTask (void * parameters)
{
    /* RS 485 in handling
     * wait for initialization
     * Listen for start delimiter -> grab MUTEX when received and start counting length:
     *      if ping: check against device ID
     *      if same channel: check against device table (contextual in/out)
     *      if special channel: check against device table
     * for ping: send permission to the output task
     * for matching or special channel: send index and message to device specific task
     */
    uint8_t buffer[MAX_MESSAGE_SIZE];
    uint8_t byte_buffer[1];
    uint8_t length = 0;
    uint8_t pos = 0;
    
    xEventGroupWaitBits(xEventInit, 0x1, pdFALSE, pdFALSE, portMAX_DELAY); // wait for init
    
    for(;;)
    {
        //wait for start delimiter
        xStreamBufferReceive(xCOMM_in_Stream, byte_buffer, 1, portMAX_DELAY);
        if(byte_buffer[0] == 0x7E)
        {
            uint8_t pos = 0;
            //next byte is length, grab length for message construction loop
            xStreamBufferReceive(xCOMM_in_Stream, byte_buffer, 1, portMAX_DELAY);
            length = byte_buffer[0];
            //loop and assemble message until length = 0;
            while(length > 0)
            {
                length--;
                xStreamBufferReceive(xCOMM_in_Stream, byte_buffer, 1, portMAX_DELAY);
                buffer[pos] = byte_buffer[0];
                pos++;
            }
        }
        //message should now be full assembled, check message type (should be index 0);
        switch(buffer[0])
        {
            case 'P': //ping
            {
                //notify output
                //release mutex
            }
            case 'R': //ping response
            {
                //ignore
                //release mutex
            }
            case 'I': //inbound message
            {
                //check channel
                //check wireless address against device table
                //(confirm full match with device table)
                //send message to DS with index
                //release mutex
            }
            case 'O': //outbound message
            {
                //check channel
                //check wired address against device table
                //(confirm full match with device table)
                //send message to DS with index
                //release mutex
            }
        }
    }
}

//interrupts go here