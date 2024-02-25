/* 
 * File:   main.c
 * Author: Michael King
 *
 * Created on February 24, 2024, 1:12 PM
 */

#define F_CPU 24000000UL //24MHz clock for delay function

#include <stdio.h>
#include <avr/io.h>
#include <util/delay.h>
#include <stdlib.h>

/*
 * 
 */
int main(int argc, char** argv) {
/*
 * In order to test microcontroller clock initialization, I will use the 
 * register macros and masks provided by the avr/io headers
 */
    // clock control testing section
    /* Protected write unlocks the protected registers that control the main clock
     * in this case, it is being used to select the internal high speed oscillator
     * as the main clock 
     */
    _PROTECTED_WRITE(CLKCTRL.MCLKCTRLA, CLKCTRL.MCLKCTRLA | CLKCTRL_CLKSEL_OSCHF_gc);
    /*
     * I will now set the clock speed to 24MHZ, the fastest available speed.
     * This register has the same CCP protection as the above, so it will require
     * a protected write
     */
    _PROTECTED_WRITE(CLKCTRL.OSCHFCTRLA, CLKCTRL.OSCHFCTRLA | CLKCTRL_FRQSEL_24M_gc);
    /*
     * That should be all the clock configuration required, now I will try to
     * configure an I/O pin as an output to flash an LED.
     * it seems that the peripheral clocks happen automatically or something,
     * I do not appear to need to enable them like I do with the STM32
     * to enable a pin as output, the header path seems to be PORTx.DIRSET
     * I will then use the pin 3 bit mask to set that pin as an output
     */
    PORTD.DIRSET = PIN3_bm;
    /*
     * now PIN3 should be configured as an output, so I will try toggling it
     * once per second
     */
    while(1)
    {
        PORTD.OUTSET = PIN3_bm;
        _delay_ms(1000);
        PORTD.OUTCLR = PIN3_bm;
        _delay_ms(1000);
    }
    return (EXIT_SUCCESS);
}

