/* ShiftReg.c
 * Created by Michael King
 * used to control the built in shift registers on boards through simple helper
 * functions
 */
#include "ShiftReg.h"

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

uint8_t ShiftIn(void)
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
    return(~digit);
}
void LTCHIn(void)
{
    //pulse high
    PORTA.OUTSET = LTCH1;
    _delay_us(50);
    PORTA.OUTCLR = LTCH1;
}
void InitShiftIn(void)
{
    // shiftin outputs
    PORTA.DIRSET = CLK1 | LTCH1;
    // shiftin inputs
    PORTA.DIRCLR = DT1;
}
void InitShiftOut(void)
{
     // shiftout outputs
    PORTA.DIRSET = DT2;
    PORTC.DIRSET = CLR2 | CLK2 | LTCH2;
}