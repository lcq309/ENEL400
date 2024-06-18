/* 
 * File:   ADC.h
 * Author: Michael King
 * Hardware drivers for the ADC
 * Will enable ADC0 and it's associated interrupt
 * No output or interrupt is defined here, those need to be handled somewhere else.
 * Assumes that the CPU is running at 24MHZ
 * Created on June 18, 2024
 */

#ifndef ADC_H
#define	ADC_H
#include <stdio.h>
#include <stdlib.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#define CPU_F 24000000 //24MHz
#ifdef	__cplusplus
extern "C" {
#endif

/* ADC_init
 * Initializes ADC to run with interrupts enabled, interrupts will need to be
 * setup depending on which device type it is.
 */
    void ADC_init(void);
#ifdef	__cplusplus
}
#endif

#endif	/* ADC_H */

