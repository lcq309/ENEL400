/* 
 * File:   main.c
 * Author: Michael King
 * Lap counter driver test software
 * Created on February 25, 2024
 */
#define F_CPU 24000000UL //24MHz clock for delay function

#include <stdio.h>
#include <stdint.h>
#include <avr/io.h>
#include <util/delay.h>
#include <stdlib.h>

#define DT2 PIN7_bm // PA7
#define CLR2 PIN0_bm // PC0
#define CLK2 PIN1_bm // PC1
#define LTCH2 PIN2_bm // PC2
#define DT1 PIN4_bm // PA4
#define CLK1 PIN6_bm // PA6
#define LTCH1 PIN5_bm // PA5

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
/*
 * 
 */
int main(int argc, char** argv) {
    uint8_t channel = 0; // byte for switch testing
    uint8_t UID = 0;
    // Clock configuration for 24MHz
    _PROTECTED_WRITE(CLKCTRL.OSCHFCTRLA, CLKCTRL.OSCHFCTRLA | CLKCTRL_FRQSEL_24M_gc);
    // initialize outputs
    // shiftout outputs
    PORTA.DIRSET = DT2;
    PORTC.DIRSET = CLR2 | CLK2 | LTCH2;
    // shiftin outputs
    PORTA.DIRSET = CLK1 | LTCH1;
    // shiftin inputs
    PORTA.DIRCLR = DT1;
    // now all inputs and outputs should be configured.
    while(1) //flash one digit, set other using a switch
    {
        _delay_ms(1000);
        CLROut();
        ShiftOut(255); //first digit is all on
        LTCHIn();
        ShiftIn(channel); //check switch 1
        ShiftIn(UID); //check switch 2
        ShiftOut(channel | UID); //set second digit based on switches ORed
        LTCHOut();
        _delay_ms(1000);
        CLROut();
        ShiftOut(0);
        LTCHIn();
        ShiftIn(channel);
        ShiftOut(channel);
        LTCHOut();
    }
    return (EXIT_SUCCESS);
}

void ShiftOut(uint8_t out)
{
    //get first bit by left shifting
    uint8_t digit = 0;
    for(uint8_t pos = 0; pos < 8; pos++)
    {
        digit = out << (7 - pos); //little endian
        digit = !!(digit >> 7); // 1 or 0
        if(digit)
            PORTA.OUTSET = DT2;
        else
            PORTA.OUTCLR = DT2;
        _delay_us(10); // delay to allow pin to change state
        PORTC.OUTSET = CLK2; // advance clock
        _delay_us(50); // delay for clock time
        PORTC.OUTCLR = CLK2;
        _delay_us(50);
    }
}
void CLROut(void)
//pulse CLR pin low
{
    PORTC.OUTCLR = CLR2;
    _delay_us(50);
    PORTC.OUTSET = CLR2;
}
void LTCHOut(void)
//pulse latch to move from shift register to output
{
    PORTC.OUTSET = LTCH2;
    _delay_us(50);
    PORTC.OUTCLR = LTCH2;
}

void ShiftIn(uint8_t* in)
//for this shift register, read first, then pulse clock, big Endian
{
    uint8_t digit = 0;
    for(uint8_t pos = 0; pos < 8; pos++)
    {
        digit |= (!(PORTA.IN & DT1) << (7- pos)); // digit is equal to not input
        //now pulse clock to advance
        PORTA.OUTSET = CLK1;
        _delay_us(50);
        PORTA.OUTCLR = CLK1;
        _delay_us(50);
    }
    in = digit;
}
void LTCHIn(void)
{
    //pulse high
    PORTA.OUTSET = LTCH1;
    _delay_us(50);
    PORTA.OUTCLR = LTCH1;
}