/* 
 * File:   RS485TASKS.c
 * Author: Michael King
 * c file that includes the RS485 IN/OUT tasks for devices on the wired network
 * as well as a small function to set them up, to be called before the scheduler starts or during initialization.
 * Created on April 22, 2024
 */

#include "RS485TASKS.h"
    struct Device GLOBAL_DEVICE_TABLE[DEVICE_TABLE_SIZE];
    
    uint8_t GLOBAL_TableLength = 0; //increments as new entries are added to the table
    uint8_t GLOBAL_NetNum = 1; //always at least one net for a wired device (our own)
    uint8_t GLOBAL_MessageSent = 1; //track whether a message has been sent or not
    
    //Timer Counters
    
    volatile uint16_t TimerCounter = 0;
    
    //MUTEXes
    
    SemaphoreHandle_t xUSART0_MUTEX;
    
    //Semaphores
    SemaphoreHandle_t xPermission; //task notification replacement
    SemaphoreHandle_t xTXC; //transmission complete flag
    SemaphoreHandle_t xNotify; //used to notify the device running task when something is received, alternative to task notification
    
    //Event Groups
    EventGroupHandle_t xEventInit;
    
    //stream handles (note device buffer is externally defined in device specific)

    StreamBufferHandle_t xCOMM_in_Stream;
    StreamBufferHandle_t xCOMM_out_Stream;
    MessageBufferHandle_t xCOMM_out_Buffer;
    MessageBufferHandle_t xDevice_Buffer;
    
    //timer handles
    
    TimerHandle_t xOFFSETTimer;
    TimerHandle_t xPeriodicJoinTimer;
    

void COMMSetup()
{
    //set clock speed (this is here because it is most important for communications)
    
    _PROTECTED_WRITE(CLKCTRL.OSCHFCTRLA, CLKCTRL_FRQSEL_24M_gc);
    
    //setup MUTEX
    
    xUSART0_MUTEX = xSemaphoreCreateMutex();
    
    //setup buffers
    
    xCOMM_in_Stream = xStreamBufferCreate(50,1); //50 bytes, triggers when a byte is added
    xCOMM_out_Stream = xStreamBufferCreate(2 * MAX_MESSAGE_SIZE, 1); //output buffer
    xCOMM_out_Buffer = xMessageBufferCreate(MAX_MESSAGE_SIZE);
    xDevice_Buffer = xMessageBufferCreate(MAX_MESSAGE_SIZE);
    
    //setup semaphore
    
    xPermission = xSemaphoreCreateBinary();
    xTXC = xSemaphoreCreateBinary();
    xNotify = xSemaphoreCreateBinary();
    
    //setup event group
    
    xEventInit = xEventGroupCreate();
    
    //setup tasks 
    
    xTaskCreate(modCOMMOutTask, "COMMOUT", (MAX_MESSAGE_SIZE + 300), NULL, mainCOMMOUT_TASK_PRIORITY, NULL);
    xTaskCreate(modCOMMInTask, "COMMIN", 400, NULL, mainCOMMIN_TASK_PRIORITY, NULL);
    
    //setup timers
    xOFFSETTimer = xTimerCreate("OFFS", 128, pdTRUE, 0, vOFFSETTimerFunc);
    xPeriodicJoinTimer = xTimerCreate("JOIN", 30000, pdTRUE, 0, vPeriodicJoinTimerFunc);
    
    //initialize USART0
    
    USART0_init();
}

void modCOMMOutTask (void * parameters)
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
        size = xMessageBufferReceive(xCOMM_out_Buffer, buffer, MAX_MESSAGE_SIZE, 0);
        //check index
        if((buffer[0] == 0xff) && (size != 0)) //if network generation message requested, load the join message into the output stream
        {
            //load join message into output
            xStreamBufferSend(xCOMM_out_Stream, netmessage, 14, 0);
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
            xStreamBufferSend(xCOMM_out_Stream, header_buffer, 14, 0);
            //load output message
            xStreamBufferSend(xCOMM_out_Stream, buffer, size - 1, 0);
        }
        } while(size != 0);
    // wait for notification (if not received then just go back to the start of the loop)
    if(xSemaphoreTake(xPermission, 500) == pdTRUE)
    {
        // load the ping response
        xStreamBufferSend(xCOMM_out_Stream, PR, 4, 0);
        // acquire hardware mutex
        xSemaphoreTake(xUSART0_MUTEX, portMAX_DELAY);
        // set transceiver to transmit mode
        RS485TR('T');
        //enable DRE interrupt
        USART0.CTRLA |= USART_DREIE_bm;
        //wait for TXcomplete notification
        xSemaphoreTake(xTXC, portMAX_DELAY);
        GLOBAL_MessageSent = 1;
        //release USART MUTEX
        xSemaphoreGive(xUSART0_MUTEX);
        //end of message, wait until permission given again
    }
    }
}

void modCOMMInTask (void * parameters)
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
    uint8_t size = 0;
    uint8_t pos = 0;
    uint8_t check = 0; //check for message failure
    
    xEventGroupWaitBits(xEventInit, 0x1, pdFALSE, pdFALSE, portMAX_DELAY); // wait for init
    //start periodic join offset timer
    xTimerStart(xOFFSETTimer, portMAX_DELAY);
    uint8_t output[2] = {'T', 'J'}; //send network join messages
    xQueueSendToBack(xDeviceIN_Queue, output, 15);
    //notify the device
    xSemaphoreGive(xNotify);
    
    for(;;)
    {
        //wait for start delimiter, can wait forever
        //(may implement a 'no activity' warning here later)
        xStreamBufferReceive(xCOMM_in_Stream, byte_buffer, 1, portMAX_DELAY);
        if(byte_buffer[0] == 0x7E)
        {
            pos = 0;
            //next byte is length, grab length for message construction loop
            check = xStreamBufferReceive(xCOMM_in_Stream, byte_buffer, 1, 10);
            if(check > 0)
            {
                length = byte_buffer[0]; // load loop iterator
                size = length; //save length for use later
                //loop and assemble message until length = 0;
                while(length > 0)
                {
                    check = xStreamBufferReceive(xCOMM_in_Stream, byte_buffer, 1, 10);
                    if(check > 0)
                    {
                        buffer[pos] = byte_buffer[0];
                        pos++;
                        length--;
                    }
                    else //message receipt failure, discard message and stop waiting
                    {
                        length = 0;
                        buffer[0] = 0;
                    }
                }
            }
            else
                buffer[0] = 0;
        }
        else //if not 0x7E, then something broke and we should not run the rest of the process
            buffer[0] = 0; //set buffer out of bounds to ensure nothing happens with a previous message.
        
        //message should now be full assembled, check message type (should be index 0)
        //release hardware MUTEX
        xSemaphoreGive(xUSART0_MUTEX);
        uint8_t matched = 0; //device table checks against this to add a new device
        uint8_t netmatch = 0; //track if a device is on the same wireless address as another to avoid redundant messages.
        switch(buffer[0])
        {
            case 'P': //ping
                //compare against device ID and notify output
                if(buffer[1] == GLOBAL_DeviceID)
                    xSemaphoreGive(xPermission);
            break;
            
            case 'R': //ping response
            break; //do nothing with ping response
            
            case 'I': //inbound message
            {
                //check channel, special channel, and menu
                if((buffer[2] == GLOBAL_Channel) || (buffer[2] == 0xff) || (buffer[2] == 0x0) || (GLOBAL_Channel == 0xff))
                {
                    matched = 'I';
                    //header structure: {start, length, type, wired address, ch, device type, wireless address}
                    //check wireless address against device table until a match is found
                    for(uint8_t i = 0; i < GLOBAL_TableLength; i++)
                    {
                        //wireless address check, start with LSB
                        for(uint8_t y = 11; y >= 4; y--)
                        {
                            if(buffer[y] != GLOBAL_DEVICE_TABLE[i].XBeeADD[y-4]) //if address doesn't match
                            {
                                y = 3; //end loop
                                matched = 'I'; //not a match
                            }
                            else
                            {
                                matched = 1;
                                netmatch = GLOBAL_DEVICE_TABLE[i].Net;
                            }
                           
                        }
                        if(matched == 1) //if the wireless address matches, perform rest of checks
                        {
                            if(buffer[1] == GLOBAL_DEVICE_TABLE[i].WiredADD)
                            {
                                matched = 1;
                                if(buffer[3] == GLOBAL_DEVICE_TABLE[i].Type) //now fully matched
                                {
                                    matched = 1;
                                    //send message to the device, with the index entry at the front
                                    buffer[0] = i;
                                    for(uint8_t x = 0; x < size - 12; x++)
                                        buffer[x + 1] = buffer[x + 12]; //move the message forwards in the buffer
                                    size = size - 12; //resize to remove the header
                                    //send to device buffer
                                    xMessageBufferSend(xDevice_Buffer, buffer, size, 50);
                                    //notify the device
                                    xSemaphoreGive(xNotify);
                                    //end looping iterations
                                    i = GLOBAL_TableLength;
                                }
                                else
                                    matched = 'I';
                            }
                            else
                                matched = 'I';
                        }
                    }
                    //at this point, matched is either 1 or 0
                    
                }
                //(confirm full match with device table)
                //send message to DS with index
            }
            break;
            
            case 'O': //outbound message
            {
                //check channel, special channel, and menu
                if((buffer[2] == GLOBAL_Channel) || (buffer[2] == 0xff) || (buffer[2] == 0x0) || (GLOBAL_Channel == 0xff))
                {
                    matched = 'O';
                    //check wired address against device table
                    for(uint8_t i = 0; i < GLOBAL_TableLength; i++)
                    {
                        if(buffer[1] == GLOBAL_DEVICE_TABLE[i].WiredADD)
                        {
                            matched = 1;
                            if(buffer[3] == GLOBAL_DEVICE_TABLE[i].Type)
                            {
                                matched = 1;
                                //wireless address check, start with LSB
                                for(uint8_t y = 11; y >= 4; y--)
                                {
                                    if(0x0 != GLOBAL_DEVICE_TABLE[i].XBeeADD[y-4]) //if this is a separate wired network
                                    {
                                        y = 3; //end loop
                                        matched = 'O'; //not a match
                                    }
                                    else
                                        matched = 1;
                                }
                                if(matched == 1)
                                {
                                    //all checks complete, send message with index
                                    //send message to the device, with the index entry at the front
                                    buffer[0] = i;
                                    for(uint8_t x = 0; x < size - 12; x++)
                                        buffer[x + 1] = buffer[x + 12]; //move the message forwards in the buffer
                                    size = size - 11; //resize to remove the header
                                    //send to device buffer
                                    xMessageBufferSend(xDevice_Buffer, buffer, size, 50);
                                    //notify the device
                                    xSemaphoreGive(xNotify);
                                    //end looping iterations
                                    i = GLOBAL_TableLength;
                                }
                            }
                        }
                        else
                            matched = 'O';
                    }
                }
                //check wired address against device table
                //(confirm full match with device table, can ignore wireless address from message and just check to ensure is all zeroes)
                //send message to DS with index
                //release mutex
                case 0: //message receipt failure, maybe an error here in the future, otherwise just do nothing
                    break;
            }
            break;
        }
        //now check if anything needs to be added to the device table
        switch(matched)
        {
            case 'O':
            {
                /* populate a new entry in the device table
                 * increment table length
                 * send message to the device specific task
                 */
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].Channel = buffer[2];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].Type = buffer[3];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].WiredADD = buffer[1];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[0] = 0x0;
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[1] = 0x0;
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[2] = 0x0;
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[3] = 0x0;
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[4] = 0x0;
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[5] = 0x0;
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[6] = 0x0;
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[7] = 0x0;
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].Net = 1; //same wired network is always net 1
                //increment length
                GLOBAL_TableLength++;
                //send message to the device, with the index entry at the front
                buffer[0] = GLOBAL_TableLength - 1;
                for(uint8_t x = 0; x < size - 12; x++)
                    buffer[x + 1] = buffer[x + 12]; //move the message forwards in the buffer
                size = size - 12; //resize to remove the header
                //send to device buffer
                xMessageBufferSend(xDevice_Buffer, buffer, size, 50);
                //notify the device
                xSemaphoreGive(xNotify);
            }
            break;
            
            case 'I':
            {
                /* populate a new entry in the device table
                 * increment table length
                 * send message to the device specific task
                 */
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].Channel = buffer[2];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].Type = buffer[3];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].WiredADD = buffer[1];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[0] = buffer[4];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[1] = buffer[5];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[2] = buffer[6];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[3] = buffer[7];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[4] = buffer[8];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[5] = buffer[9];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[6] = buffer[10];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[7] = buffer[11];
                //netmatch check here
                if(netmatch == 0)
                {
                    GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].Net = (GLOBAL_NetNum + 1);
                    GLOBAL_NetNum++;
                }
                else
                    GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].Net = netmatch;
                //increment length
                GLOBAL_TableLength++;
                //send message to the device, with the index entry at the front
                buffer[0] = GLOBAL_TableLength - 1;
                for(uint8_t x = 0; x < size - 12; x++)
                    buffer[x + 1] = buffer[x + 12]; //move the message forwards in the buffer
                size = size - 12; //resize to remove the header
                //send to device buffer
                xMessageBufferSend(xDevice_Buffer, buffer, size, 50);
                //notify the device
                xSemaphoreGive(xNotify);
            }
            break;
            
            case 1: //matched, do nothing
                break;
                
            case 0: //not matched, future error here
                break;
        }
    }
}


//timer functions
void vOFFSETTimerFunc( TimerHandle_t xTimer )
{
    //if current offset is greater than or equal to device ID
    if(TimerCounter >= GLOBAL_DeviceID)
    {
       //start periodical timer
       TimerCounter = 0;
       xTimerStart(xPeriodicJoinTimer, portMAX_DELAY);
       xTimerStop(xOFFSETTimer, portMAX_DELAY);
    }
    else
        TimerCounter++;
}

void vPeriodicJoinTimerFunc( TimerHandle_t xTimer )
{
    //send 3x net join to comms out stream
    uint8_t output[2] = {'T', 'J'};
     xQueueSendToBack(xDeviceIN_Queue, output, 15);
    //notify the device
    xSemaphoreGive(xNotify);
}

//interrupts go here

ISR(USART0_RXC_vect)
{
    /* Receive complete interrupt
     * move received byte into byte buffer for RS485 in task
     */
    uint8_t buf[1];
    buf[0] = USART0.RXDATAL;
    xMessageBufferSendFromISR(xCOMM_in_Stream, buf, 1, NULL);
}
ISR(USART0_DRE_vect)
{
    /* Data Register empty Interrupt
     * 1. pull from output stream buffer and put in TX register until clear
     * 2. disable interrupt
     */
    uint8_t buf[1];
    if(xStreamBufferReceiveFromISR(xCOMM_out_Stream, buf, 1, NULL) == 0) //if end of message
        USART0.CTRLA &= ~USART_DREIE_bm; //disable interrupt
    else
        USART0.TXDATAL = buf[0];
}
ISR(USART0_TXC_vect)
{
    /* Transmission complete interrupts
     * 1. set semaphore
     * 2. clear interrupt flag
     */
    // set transceiver to receive mode
    RS485TR('R');
    USART0.STATUS |= USART_TXCIF_bm; //clear flag by writing a 1 to it
    xSemaphoreGiveFromISR(xTXC, NULL); //send notification to output task
}