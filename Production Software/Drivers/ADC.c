/* 
 * File:   ADC.c
 * Author: Michael King
 * Hardware drivers for the ADC
 * Will enable ADC0 and it's associated interrupt
 * No output or interrupt is defined here, those need to be handled somewhere else.
 */

#include "ADC.h"

void ADC_init(void)
{
    //start by disabling global interrupts (if they are enabled)
    SREG &= ~CPU_I_bm; //set interrupt enable to zero to disable global interrupts
    //configure VREF as VDD (approx 3.3v)
    VREF.ADC0REF = VREF_REFSEL_VDD_gc;
    //configure as single-ended (default setting)
    //configure for 12 bit (default setting)
    //configure prescaler for 1/128 clock speed
    ADC0.CTRLC = ADC_PRESC_DIV128_gc;
    //we will not select an input yet, we will send this to ground to avoid causing damage unintentionally.
    ADC0.MUXPOS = ADC_MUXPOS_GND_gc;
    //enable RESRDY interrupt
    ADC0.INTCTRL = ADC_RESRDY_bm;
    //enable ADC
    ADC0.CTRLA |= ADC_ENABLE_bm;
    //re-enable global interrupts
    SREG |= ~CPU_I_bm;
    //USART0 now initialized for 8bit, even parity, interrupt driven mode
}