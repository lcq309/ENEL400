/* 
 * File:   main.c
 * Author: Michael King
 * Purpose: Testing of the button module hardware
 * Created on February 24, 2024
 */

#include <stdio.h>
#include <stdlib.h>
#include <avr/io.h>

#define I1 PIN1_bm
#define I2 PIN0_bm
#define I3 PIN7_bm
#define B1 PIN6_bm //PD6
#define B2 PIN5_bm //PD5
#define B3 PIN3_bm //PD3
#define B4 PIN2_bm //PD2
#define B5 PIN3_bm //PC3

void I1_on(void);
void I1_off(void);

void I2_on(void);
void I2_off(void);

void I3_on(void);
void I3_off(void);

/*
 * 
 */
int main(int argc, char** argv) {
    // Clock configuration for 24MHz
    _PROTECTED_WRITE(CLKCTRL.OSCHFCTRLA, CLKCTRL.OSCHFCTRLA | CLKCTRL_FRQSEL_24M_gc);
    // initialize outputs
    PORTC.DIRSET = I1 | I2;
    PORTA.DIRSET = I3;
    // initialize inputs
    PORTD.DIRCLR = B1 | B2 | B3 | B4;
    PORTC.DIRCLR = B5;
    // pullup resistor on each input
    // multipin configuration for PORT D
    PORTD.PINCONFIG = PORT_PULLUPEN_bm;
    PORTD.PINCTRLUPD = B1 | B2 | B3 | B4;
    // single pin configuration for PORT C
    PORTC.PIN3CTRL |= PORT_PULLUPEN_bm;
    // now all inputs and outputs should be configured.
    
    while(1)
    {
        if(!(PORTD.IN & B1)) // if button one is pressed
        {
           I1_on(); 
        }
        else if(!(PORTD.IN & B2)) // if button two is pressed
        {
            I2_on();
        }
        else if(!(PORTD.IN & B3)) // if button three is pressed
        {
            I3_on();
        }
        else if(!(PORTD.IN & B4)) // if button four is pressed
        {
            I1_on();
            I2_on();
        }
        else if(!(PORTD.IN & B5)) // if button five is pressed
        {
            I1_on();
            I2_on();
            I3_on();
        }
        else
        {
            I1_off();
            I2_off();
            I3_off();
        }
    }
    
    return (EXIT_SUCCESS);
}

void I1_on(void)
{
    PORTC.OUTSET = I1;
}
void I1_off(void)
{
    PORTC.OUTCLR = I1;
}
void I2_on(void)
{
    PORTC.OUTSET = I2;
}
void I2_off(void)
{
    PORTC.OUTCLR = I2;
}
void I3_on(void)
{
    PORTA.OUTSET = I3;
}
void I3_off(void)
{
    PORTA.OUTCLR = I3;
}