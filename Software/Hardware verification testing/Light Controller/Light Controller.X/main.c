/* 
 * File:   main.c
 * Author: Michael King
 * Purpose: Testing of the light driver module hardware
 * Created on February 24, 2024
 */

#define F_CPU 24000000 //24MHz clock for delay function

#include <stdio.h>
#include <stdlib.h>
#include <util/delay.h>
#include <avr/io.h>

#define RSIG PIN2_bm //PC2
#define GSIG PIN3_bm //PC3
#define BSIG PIN0_bm //PD0
#define YSIG PIN1_bm //PD1


void RSIG_on(void);
void RSIG_off(void);

void GSIG_on(void);
void GSIG_off(void);

void BSIG_on(void);
void BSIG_off(void);

void YSIG_on(void);
void YSIG_off(void);
/*
 * 
 */
int main(int argc, char** argv) {
     // Clock configuration for 24MHz
    _PROTECTED_WRITE(CLKCTRL.OSCHFCTRLA, CLKCTRL.OSCHFCTRLA | CLKCTRL_FRQSEL_24M_gc);
    // initialize outputs
    PORTC.DIRSET = RSIG | GSIG;
    PORTD.DIRSET = BSIG | YSIG;
    // now all outputs should be configured
    while(1)
    {
        GSIG_on();
        BSIG_off();
        _delay_ms(1000);
        YSIG_on();
        GSIG_off();
        _delay_ms(1000);
        RSIG_on();
        YSIG_off();
        _delay_ms(1000);
        BSIG_on();
        RSIG_off();
        _delay_ms(1000);
    }
    return (EXIT_SUCCESS);
}

void RSIG_on(void)
{
    PORTC.OUTSET = RSIG;
}
void RSIG_off(void)
{
    PORTC.OUTCLR = RSIG;
}
void GSIG_on(void)
{
    PORTC.OUTSET = GSIG;
}
void GSIG_off(void)
{
    PORTC.OUTCLR = GSIG;
}
void BSIG_on(void)
{
    PORTD.OUTSET = BSIG;
}
void BSIG_off(void)
{
    PORTD.OUTCLR = BSIG;
}
void YSIG_on(void)
{
    PORTD.OUTSET = YSIG;
}
void YSIG_off(void)
{
    PORTD.OUTCLR = YSIG;
}