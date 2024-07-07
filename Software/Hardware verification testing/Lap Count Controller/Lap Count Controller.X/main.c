/* 
 * File:   main.c
 * Author: Michael King
 * Lap counter controller test software
 * Created on February 25, 2024
 */

#define F_CPU 24000000UL //24MHz clock for delay function

#include <stdio.h>
#include <stdint.h>
#include <avr/io.h>
#include <util/delay.h>
#include <stdlib.h>

#define SDA PIN2_bm //PA2 TWI0
#define SCL PIN3_bm //PA3 TWI0
#define up PIN6_bm //PD6
#define down PIN5_bm //PD5
#define half PIN3_bm //PD3
#define zero PIN2_bm //PD2
#define last PIN3_bm //PC3
#define CLK_PER                                         24000000     // 24MHz clock
#define TWI0_BAUD(F_SCL, T_RISE)                        ((((((float)CLK_PER / (float)F_SCL)) - 10 - ((float)CLK_PER * T_RISE))) / 2)
#define I2C_SCL_FREQ                                    100000

void I2C_init(void)
{
    //// first set the SDA hold time, FM Plus enable defaults to zero
    //TWI0.CTRLA |= TWI_SDAHOLD_500NS_gc;
    TWI0.MBAUD = (uint8_t)TWI0_BAUD(I2C_SCL_FREQ, 0);
    //now enable the TWI as a host
    TWI0.MCTRLA |= TWI_ENABLE_bm | TWI_SMEN_bm; //enable host and smart mode
    //set the bus state to idle
    TWI0.MSTATUS |= TWI_BUSSTATE_IDLE_gc;
    //TWI should now be initialized and ready to use
}
/*
 * 
 */
/*
 * I2C_init()
 * initializes the TWI module
 * ensure that the correct module is specified within the function code
 */
void I2C_init(void);
/*
 * I2C_transmit(Address, Message, len)
 * sends a message (message) of length (len) in bytes to the address indicated 
 * in (address).
 * intended to be used for write operations, a separate function for read will
 * be created
 * returns a 0 if successful with no issues
 */
uint8_t I2C_transmit(uint8_t Address, uint8_t *Message, uint8_t len);
/*
 * I2C_read(Address, command, *received)
 * reads from an I2C device at address, according to the command, and stores the
 * result in the byte or byte array pointed to by received. Sends NACK depending
 * on len when appropriate.
 * returns a 0 if successful with no issues
 */
uint8_t I2C_read(uint8_t Address, uint8_t command, uint8_t *received, uint8_t len);
int main(int argc, char** argv) {
    // Clock configuration for 24MHz
    _PROTECTED_WRITE(CLKCTRL.OSCHFCTRLA, CLKCTRL.OSCHFCTRLA | CLKCTRL_FRQSEL_24M_gc);
    PORTD.DIRCLR = up | down | half | zero;
    PORTC.DIRCLR = last;
    // pullup resistor on each input
    // multipin configuration for PORT D
    PORTD.PINCONFIG = PORT_PULLUPEN_bm;
    PORTD.PINCTRLUPD = up | down | half | zero;
    // single pin configuration for PORT C
    PORTC.PIN3CTRL |= PORT_PULLUPEN_bm;
    // now all inputs and outputs should be configured.
    
    I2C_init();
    
    return (EXIT_SUCCESS);
}
void I2C_init(void)
{
    // first set the SDA hold time, FM Plus enable defaults to zero
    TWI0.CTRLA |= TWI_SDAHOLD_500NS_gc;
    /* 
     * now set the baud rate (calculation in documentation) should result in
     * approximately 200khz tx frequency
     */
    TWI0.MBAUD = 51;
    //now enable the TWI as a host
    TWI0.MCTRLA |= TWI_ENABLE_bm; //enable host and smart mode
    //set the bus state to idle
    TWI0.MSTATUS |= TWI_BUSSTATE_IDLE_gc;
    //TWI should now be initialized and ready to use
}

uint8_t I2C_transmit(uint8_t Address, uint8_t *Message, uint8_t len)
{
    /* Place address into address register (after adding r/w), 
     * then message into message and wait
     * for transmission to finish. Loop through len and Message byte array
     * until all messages are sent, wait for ACK between messages, then STOP
     * intended to be use for WRITE operations
     */
    /*first, write to address register to start address transmission 
     * wait for !RXACK(received ACK) and can also check WIF (write interrupt flag)
     * ,Arbitration lost, and Bus error should also be zero.
     */
    TWI0.MADDR = Address & ~0x1; // write has a zero in the first bit
    while(!(TWI0.MSTATUS & TWI_WIF_bm)); // Write Interrupt Flag set high
    if(TWI0.MSTATUS & TWI_RXACK_bm)
    {
        return(1); //one for a communication error
    } // Received Acknowledge if no error, if NACK then something is wrong
    //then send Byte-by-Byte until the length is reached, wait for ACK in between
    for(int i = 0; i < len; i++)
    {
        TWI0.MDATA = Message[i]; //write the message to the data register
        while(!(TWI0.MSTATUS & TWI_WIF_bm));//wait for Write interrupt to go high
        if(TWI0.MSTATUS & TWI_RXACK_bm)
        {
            return(1); //one for a communication error
        } // Received Acknowledge if no error, if NACK then something is wrong
    }
    //after sending the message, send a STOP over the bus by writing to MCMD field
    TWI0.MCTRLB |= TWI_MCMD_STOP_gc;
    return(0); //return 0 for successful transmission
}

uint8_t I2C_read(uint8_t Address, uint8_t command, uint8_t *received, uint8_t len)
{
    /* The read sequence is similar to the write sequence, but after sending the
     command it will resend the Address with the R/W bit set, and store what it 
     receives in the array pointed to by *received */
    uint8_t success = I2C_transmit(Address, command, 1);
    if(success != 0) //if command transmission is not successful
    {
        return(success); //return with the transmit error number
    }
    // after sending command, send the address with the write bit set
    TWI0.MADDR = (Address | 0x1); //R/W set to read
    while(!(TWI0.MSTATUS & TWI_WIF_bm)); // Write Interrupt Flag set high
    if(TWI0.MSTATUS & TWI_RXACK_bm) //acknowledge reception and check
    {
        return(1);
    }
    /*
     * now begin reading bytes to the buffer pointed to by received
     * send ACK between bytes and NACK once length is reached.
     */
    for(int i = 0; i < len; i++)
    {
        while(!(TWI0.MSTATUS & TWI_RIF_bm)); //wait until read is complete
        received[i] = TWI0.MDATA; //read the data register into the receiver array.
        //send ACK happens automatically from configuration settings (SMEN)
    }
    //after looping complete, send a NACK and a stop state.
    TWI0.MCTRLB |= TWI_ACKACT_NACK_gc; // send NACK
    TWI0.MCTRLB |= TWI_MCMD_STOP_gc; // send STOP
}

