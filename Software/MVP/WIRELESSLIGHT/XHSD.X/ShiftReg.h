/* 
 * File:   ShiftReg.h
 * Author: Michael King
 * Software drivers for the Shift Registers
 * Need manual targeting if not on the default shift register pins
 * Created on March 20, 2024, 5:50 PM
 */

#ifndef SHIFTREG_H
#define	SHIFTREG_H
#include <stdio.h>
#include <stdlib.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#define DT2 PIN7_bm // PA7
#define CLR2 PIN0_bm // PC0
#define CLK2 PIN1_bm // PC1
#define LTCH2 PIN2_bm // PC2
#define DT1 PIN4_bm // PA4
#define CLK1 PIN6_bm // PA6
#define LTCH1 PIN5_bm // PA5

#ifdef	__cplusplus
extern "C" {
#endif

/* InitShiftIn(void)
 * InitShiftIn initializes the pins needed to drive the input shift registers
 */    
void InitShiftIn(void);
/* InitShiftOut(void)
 * InitShiftOut initializes the pins needed to drive the output shift registers
 */
void InitShiftOut(void);
/*
 * ShiftOut(out)
 * shifts an 8-bit integer out, one bit at a time, Little Endian.
 * out is an 8 bit integer
 * pulses the clock line and serial line set within the function
 * Ensure that the target is correct, requires an external latch when complete
 * requires the util/delay.h library, for internal microsecond delays
 */
void ShiftOut(uint8_t out);
/*
 * CLROut
 * Clears the 8 bit shift register by pulsing the CLR line low
 * Ensure the correct target is selected for the CLR line
 */
void CLROut(void);
/*
 * LTCHOut
 * Latches the 8 bit shift register by pulsing the LTCH line high
 * Ensure the correct target is selected for the LTCH line
 */
void LTCHOut(void);
/*
 * ShiftIn(in)
 * shifts an 8-bit integer into in, one bit at a time. This is Big Endian.
 * The first bit will be the MSB, and go down from there.
 * pulses the clock line and checks the input of the input set within the
 * function.
 * specifically intended for the CD4021BC chip, will read first before pulsing
 * Ensure that the correct lines are selected and initialized.
 * requires external handling of P/S
 * requires the util/delay.h library, for internal microsecond delays
 */
void ShiftIn(uint8_t* in);
/*
 * LTCHIn();
 * Pulses input latch high to save switch state
 * ensure that correct lines are selected
 */
void LTCHIn(void);

#ifdef	__cplusplus
}
#endif

#endif	/* SHIFTREG_H */

