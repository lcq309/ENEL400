/* 
 * File:   XBEETASKS.c
 * Author: Michael King
 * c file that includes the XBEE IN/OUT tasks for devices on the wireless network
 * as well as a small function to set them up, to be called before the scheduler starts or during initialization.
 * Created on July 7, 2024
 */

#include "XBEETASKS.h"
    struct Device GLOBAL_DEVICE_TABLE[DEVICE_TABLE_SIZE];
    
    uint8_t GLOBAL_TableLength = 0; //increments as new entries are added to the table
    uint8_t GLOBAL_NetNum = 1; //always at least one net for a wired device (our own)
    uint8_t GLOBAL_MessageSent = 1; //track whether a message has been sent or not
    
    //Timer Counters
    
    volatile uint16_t TimerCounter = 0;
    
    //Semaphores
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
    
    //setup buffers
    
    xCOMM_in_Stream = xStreamBufferCreate(50,1); //50 bytes, triggers when a byte is added
    xCOMM_out_Stream = xStreamBufferCreate(2 * MAX_MESSAGE_SIZE, 1); //output buffer
    xCOMM_out_Buffer = xMessageBufferCreate(MAX_MESSAGE_SIZE);
    xDevice_Buffer = xMessageBufferCreate(MAX_MESSAGE_SIZE);
    
    //setup semaphore
    
    xTXC = xSemaphoreCreateBinary();
    xNotify = xSemaphoreCreateBinary();
    
    //setup event group
    
    xEventInit = xEventGroupCreate();
    
    //setup tasks 
    
    xTaskCreate(modCOMMOutTask, "COMMOUT", (MAX_MESSAGE_SIZE + 300), NULL, mainCOMMOUT_TASK_PRIORITY, NULL);
    xTaskCreate(modCOMMInTask, "COMMIN", 400, NULL, mainCOMMIN_TASK_PRIORITY, NULL);
    
    //setup timers
    xOFFSETTimer = xTimerCreate("OFFS", 32, pdTRUE, 0, vOFFSETTimerFunc);
    xPeriodicJoinTimer = xTimerCreate("JOIN", 50, pdTRUE, 0, vPeriodicJoinTimerFunc);
    
    //initialize USART0
    
    USART0_init();
}

void modCOMMOutTask (void * parameters)
{
    /* XBEE out handling
     * wait for initialization to complete
     * loop:
     * 1. generate message destination header from pointed index entry
     * 2. load header into output stream
     * 3. load message into output stream
     * clear output buffer by setting DREIE (needs testing to determine if output buffer needs to be pre-fed to trigger interrupt)
     * DREI is disabled by the TXC Interrupt
     */
    uint32_t checksumcalc = 0;
    uint8_t buffer[MAX_MESSAGE_SIZE];
    uint8_t header_buffer[20];
    uint8_t length = 0;
    uint8_t size = 0;
    //uint8_t netmessage[14] = {0x7e, 12, 'O', GLOBAL_DeviceID, GLOBAL_Channel, GLOBAL_DeviceType, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xFF, 0xFF};
    uint8_t netmessage[21] = {0x7e, 0x00, 0x11, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFE, 0x00, 0x00, GLOBAL_DeviceID, GLOBAL_Channel, GLOBAL_DeviceType, 0x0};  
    // header and message bits
    xEventGroupWaitBits(xEventInit, 0x1, pdFALSE, pdFALSE, portMAX_DELAY); // wait for init
    //at this point, we should have all the needed info to populate the netmessage checksum
    for(uint8_t i = 3; i < 20; i++)
    {
        checksumcalc += netmessage[i];
    }
    netmessage[20] = 0xff - (checksumcalc & 0xff);
    for(;;) //begin main loop
    {
        checksumcalc = 0;
        //loop through messages, send one at a time to the XBEE with the header attached
        size = xMessageBufferReceive(xCOMM_out_Buffer, buffer, MAX_MESSAGE_SIZE, 500);
        //check index
        if((buffer[0] == 0xff) && (size != 0)) //if network generation message requested, load the join message into the output stream
        {
            //load join message into output
            xStreamBufferSend(xCOMM_out_Stream, netmessage, 21, 0);
        }
        else if(size != 0) //generate header based on the information at the index, and load into the output stream with the message
        {
            //end of message contains the index of the target device.
            //reduce length by one, since we won't be sending the index value
            length = size - 1;
            length = length + 17; //add header to length
            header_buffer[0] = 0x7e; //start delimiter
            header_buffer[1] = 0x00; //length MSB
            header_buffer[2] = length; //length LSB
            header_buffer[3] = 0x10; //Transmit request
            header_buffer[4] = 0x00; //no frame ID
            header_buffer[5] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].XBeeADD[0]; //destination address
            header_buffer[6] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].XBeeADD[1];
            header_buffer[7] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].XBeeADD[2];
            header_buffer[8] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].XBeeADD[3];
            header_buffer[9] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].XBeeADD[4];
            header_buffer[10] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].XBeeADD[5];
            header_buffer[11] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].XBeeADD[6];
            header_buffer[12] = GLOBAL_DEVICE_TABLE[buffer[size - 1]].XBeeADD[7];
            header_buffer[13] = 0xff; //start of 16 bit address
            header_buffer[14] = 0xfe; //end of 16 bit address
            header_buffer[15] = 0x00; //broadcast radius
            header_buffer[16] = 0x00; //no transmission options
            header_buffer[17] = GLOBAL_DeviceID;
            header_buffer[18] = GLOBAL_Channel;
            header_buffer[19] = GLOBAL_DeviceType;
            //load output header
            xStreamBufferSend(xCOMM_out_Stream, header_buffer, 20, 0);
            //calculate checksum and load it into the buffer
            for(uint8_t i = 3; i < 20; i++)
            {
                checksumcalc += header_buffer[i];
            }
            for(uint8_t i = 0; i < (size - 1); i++) //do not include the index
            {
                checksumcalc += buffer[i];
            }
            buffer[size - 1] = 0xff - (checksumcalc & 0xff);
            //load output message (includes checksum on end, replacing the index)
            xStreamBufferSend(xCOMM_out_Stream, buffer, size, 0);
        }
        if(size != 0)
        {
            //enable DRE interrupt
            USART0.CTRLA |= USART_DREIE_bm;
            //wait for TXcomplete notification
            xSemaphoreTake(xTXC, portMAX_DELAY);
            GLOBAL_MessageSent = 1;
        }
    }
}

void modCOMMInTask (void * parameters)
{
    /* Wireless in handling
     * wait for initialization
     * Listen for start delimiter -> grab length and start counting
     *      depending on message type:
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
            //next 2 bytes are length, grab length for message construction loop
            //if the length is greater than 255, we are gonna have a bad time to begin with
            //just discard the first byte
            check = xStreamBufferReceive(xCOMM_in_Stream, byte_buffer, 1, 10);
            if(check > 0)
            {
                xStreamBufferReceive(xCOMM_in_Stream, byte_buffer, 1, 10);
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
        uint8_t matched = 0; //device table checks against this to add a new device
        uint8_t netmatch = 0; //track if a device is on the same wireless address as another to avoid redundant messages.
        switch(buffer[0])
        {
            case 0x90: //receive packet
                //first check the channel number against our own
                /* XBEE + OUR HEADER
                 * byte 0 = frame type
                 * byte 1 = start of 64 bit address
                 * -
                 * byte 8 = end of 64 bit address
                 * byte 9 = start of 16 bit address 
                 * byte 10 = end of 16 bit address
                 * byte 11 = Receive options field
                 * byte 12 = start of our header (WiredADD)
                 * byte 13 = Channel #
                 * byte 14 = Device Type
                 * byte 15 = start of message
                 * byte n = end of message
                 * n+1 = checksum (not captured)
                 */
                if((buffer[13] == GLOBAL_Channel) || (buffer[13] == 0xff) || (buffer[13] == 0x0) || (GLOBAL_Channel == 0xff))
                {
                    matched = 0x90;
                    for(uint8_t i = 0; i < GLOBAL_TableLength; i++)
                    {
                        //wireless address check, start with LSB
                        for(uint8_t y = 8; y >= 1; y--)
                        {
                            if(buffer[y] != GLOBAL_DEVICE_TABLE[i].XBeeADD[y-1]) //if address doesn't match
                            {
                                y = 0; //end loop
                                matched = 0x90; //not a match
                            }
                            else
                            {
                                matched = 1;
                                netmatch = GLOBAL_DEVICE_TABLE[i].Net;
                            }
                           
                        }
                        if(matched == 1) //if the wireless address matches, perform rest of checks
                        {
                            if(buffer[12] == GLOBAL_DEVICE_TABLE[i].WiredADD)
                            {
                                matched = 1;
                                if(buffer[14] == GLOBAL_DEVICE_TABLE[i].Type) //now fully matched
                                {
                                    matched = 1;
                                    //send message to the device, with the index entry at the front
                                    buffer[0] = i;
                                    for(uint8_t x = 0; x < size - 15; x++)
                                        buffer[x + 1] = buffer[x + 15]; //move the message forwards in the buffer
                                    size = size - 15; //resize to remove the header
                                    //send to device buffer
                                    xMessageBufferSend(xDevice_Buffer, buffer, size, 50);
                                    //notify the device
                                    xSemaphoreGive(xNotify);
                                    //end looping iterations
                                    i = GLOBAL_TableLength;
                                }
                                else
                                    matched = 0x90;
                            }
                            else
                                matched = 0x90;
                        }
                    }
                    
                }
                break;
        }
        //now check if anything needs to be added to the device table
        switch(matched)
        {
            case 0x90:
                /* populate a new entry in the device table
                 * increment table length
                 * send message to the device specific task
                 */
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].Channel = buffer[13];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].Type = buffer[14];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].WiredADD = buffer[12];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[0] = buffer[1];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[1] = buffer[2];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[2] = buffer[3];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[3] = buffer[4];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[4] = buffer[5];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[5] = buffer[6];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[6] = buffer[7];
                GLOBAL_DEVICE_TABLE[GLOBAL_TableLength].XBeeADD[7] = buffer[8];
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
                for(uint8_t x = 0; x < size - 15; x++)
                    buffer[x + 1] = buffer[x + 15]; //move the message forwards in the buffer
                size = size - 15; //resize to remove the header
                //send to device buffer
                xMessageBufferSend(xDevice_Buffer, buffer, size, 50);
                //notify the device
                xSemaphoreGive(xNotify);
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
        TimerCounter = 0xff;
       xTimerStart(xPeriodicJoinTimer, portMAX_DELAY);
       xTimerStop(xOFFSETTimer, portMAX_DELAY);
    }
    else
        TimerCounter++;
}

void vPeriodicJoinTimerFunc( TimerHandle_t xTimer )
{
    if(TimerCounter >= 120)
    {
        //send 3x net join to comms out stream
        uint8_t output[2] = {'T', 'J'};
        xQueueSendToBack(xDeviceIN_Queue, output, 15);
        //notify the device
        xSemaphoreGive(xNotify);
        TimerCounter = 0;
    }
    else
        TimerCounter++;
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
    USART0.STATUS |= USART_TXCIF_bm; //clear flag by writing a 1 to it
    xSemaphoreGiveFromISR(xTXC, NULL); //send notification to output task
}