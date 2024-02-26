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
uint8_t I2C_transmsit(uint8_t Address, uint8_t *Message, uint8_t len);
/*
 * I2C_read(Address, command, *received)
 * reads from an I2C device at address, according to the command, and stores the
 * result in the byte or byte array pointed to by received. Sends NACK depending
 * on len.
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
    TWI0.MCTRLA |= TWI_ENABLE_bm;
    //set the bus state to idle
    TWI0.MSTATUS |= TWI_BUSSTATE_IDLE_gc;
    //TWI should now be initialized and ready to use
}