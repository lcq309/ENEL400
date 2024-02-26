/* 
 * File:   main.c
 * Author: Michael King
 * Purpose: Testing of the marshal controller hardware
 * Created on February 24, 2024
 */

#include <stdio.h>
#include <stdlib.h>
#include <avr/io.h>

#define GBut PIN4_bm    //PD4
#define BBut PIN5_bm    //PD5
#define YBut PIN6_bm    //PD6

#define Stat PIN0_bm    //PC0
#define YInd PIN3_bm    //PC3
#define BInd PIN1_bm    //PD1
#define GInd PIN3_bm    //PD3

/*
 * 
 */
void Stat_on(void);
void Stat_off(void);

void YInd_on(void);
void YInd_off(void);

void BInd_on(void);
void BInd_off(void);

void GInd_on(void);
void GInd_off(void);

int main(int argc, char** argv) {
    // Clock configuration for 24MHz
    _PROTECTED_WRITE(CLKCTRL.OSCHFCTRLA, CLKCTRL.OSCHFCTRLA | CLKCTRL_FRQSEL_24M_gc);
    // initialize outputs
    PORTC.DIRSET = Stat | YInd;
    PORTD.DIRSET = BInd | GInd;
    // initialize inputs
    PORTD.DIRCLR = GBut | BBut | YBut;
    // pullup resistor on each input
    // multipin configuration for PORT D
    PORTD.PINCONFIG = PORT_PULLUPEN_bm;
    PORTD.PINCTRLUPD = GBut | BBut | YBut;
    // now all inputs and outputs should be configured.
    while(1)
    {
        if(!(PORTD.IN & GBut)) // if green button is pressed
        {
           Stat_on();
           GInd_on();
        }
        else if(!(PORTD.IN & BBut)) // if blue button is pressed
        {
            Stat_on();
            BInd_on();
        }
        else if(!(PORTD.IN & YBut)) // if yellow button is pressed
        {
            Stat_on();
            YInd_on();
        }
        else
        {
            Stat_off();
            BInd_off();
            YInd_off();
            GInd_off();
        }
    }
    return (EXIT_SUCCESS);
}
void Stat_on(void)
{
    PORTC.OUTSET = Stat;
}
void Stat_off(void)
{
    PORTC.OUTCLR = Stat;
}
void YInd_on(void)
{
    PORTC.OUTSET = YInd;
}
void YInd_off(void)
{
    PORTC.OUTCLR = YInd;
}
void BInd_on(void)
{
    PORTD.OUTSET = BInd;
}
void BInd_off(void)
{
    PORTD.OUTCLR = BInd;
}
void GInd_on(void)
{
    PORTD.OUTSET = GInd;
}
void GInd_off(void)
{
    PORTD.OUTCLR = GInd;
}