/* 
 * File:   main.c
 * Author: Michael King
 *
 * Created on February 24, 2024, 1:12 PM
 */

#include <stdio.h>
#include <avr/io.h>
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
     */
    return (EXIT_SUCCESS);
}

