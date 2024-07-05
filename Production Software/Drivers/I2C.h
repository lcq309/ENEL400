/* 
 * File:   I2C.h
 * Author: Michael King
 * Hardware drivers for the I2C
 * Will enable I2C and the write interrupt flag
 * No output or interrupt is defined here, those need to be handled somewhere else.
 * Assumes that the CPU is running at 24MHZ
 * Created on July 5, 2024
 */

#ifndef I2C_H
#define	I2C_H
#include <stdio.h>
#include <stdlib.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#define CPU_F 24000000 //24MHz
#ifdef	__cplusplus
extern "C" {
#endif

/* I2C_init
 * Initializes I2C to run with interrupts enabled, interrupts will need to be
 * setup depending on which device type it is.
 */
    void I2C_init(void);

/* I2C_translate
 * translates a single 8 bit character to a 16 bit stream to be sent to the display
 */
    uint16_t I2C_translate(uint8_t character);
    
#ifdef	__cplusplus
}
#endif

#endif	/* ADC_H */

