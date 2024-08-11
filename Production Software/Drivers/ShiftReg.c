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
        vTaskDelay(1);
        PORTC.OUTSET = CLK2; // advance clock
        vTaskDelay(1);
        PORTC.OUTCLR = CLK2;
    }
}
void CLROut(void)
//pulse CLR pin low
{
    PORTC.OUTCLR = CLR2;
    vTaskDelay(1);
    PORTC.OUTSET = CLR2;
}
void LTCHOut(void)
//pulse latch to move from shift register to output
{
    PORTC.OUTSET = LTCH2;
    vTaskDelay(1);
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

uint8_t ShiftTranslate (uint8_t in)
{
    uint8_t result;
    switch (in)
    {
        case '0':
            result = 222;
            break;
        case '1':
            result = 6;
            break;
        case '2':
            result = 186;
            break;
        case '3':
            result = 174;
            break;
        case '4':
            result = 102;
            break;
        case '5':
            result = 236;
            break;
        case '6':
            result = 252;
            break;
        case '7':
            result = 134;
            break;
        case '8':
            result = 254;
            break;
        case '9':
            result = 238;
            break;
        case 'A':
            result = 246;
            break;
        case 'B':
            result = 254;
            break;
        case 'C':
            result = 216;
            break;
        case 'D':
            result = 158;
            break;
        case 'E':
            result = 248;
            break;
        case 'F':
            result = 240;
            break;
        case 'G':
            result = 220;
            break;
        case 'H':
            result = 118;
            break;
        case 'I':
            result = 80;
            break;
        case 'J':
            result = 14;
            break;
        case 'K':
            result = 244;
            break;
        case 'L':
            result = 88;
            break;
        case 'M':
            result = 202;
            break;
        case 'N':
            result = 214;
            break;
        case 'O':
            result = 222;
            break;
        case 'P':
            result = 214;
            break;
        case 'Q':
            result = 222;
            break;
        case 'R':
            result = 250;
            break;
        case 'S':
            result = 236;
            break;
        case 'T':
            result = 208;
            break;
        case 'U':
            result = 94;
            break;
        case 'V':
            result = 78;
            break;
        case 'W':
            result = 156;
            break;
        case 'X':
            result = 168;
            break;
        case 'Y':
            result = 106;
            break;
        case 'Z':
            result = 186;
            break;
        case 'a':
            result = 44;
            break;
        case 'b':
            result = 124;
            break;
        case 'c':
            result = 56;
            break;
        case 'd':
            result = 62;
            break;
        case 'e':
            result = 24;
            break;
        case 'f':
            result = 112;
            break;
        case 'g':
            result = 184;
            break;
        case 'h':
            result = 116;
            break;
        case 'i':
            result = 152;
            break;
        case 'j':
            result = 140;
            break;
        case 'k':
            result = 232;
            break;
        case 'l':
            result = 80;
            break;
        case 'm':
            result = 180;
            break;
        case 'n':
            result = 52;
            break;
        case 'o':
            result = 60;
            break;
        case 'p':
            result = 242;
            break;
        case 'q':
            result = 230;
            break;
        case 'r':
            result = 48;
            break;
        case 's':
            result = 12;
            break;
        case 't':
            result = 120;
            break;
        case 'u':
            result = 28;
            break;
        case 'v':
            result = 12;
            break;
        case 'w':
            result = 74;
            break;
        case 'x':
            result = 40;
            break;
        case 'y':
            result = 110;
            break;
        case 'z':
            result = 40;
            break;
        case ' ':
            result = 0;
            break;
        default:
            result = 0xff;
            break;
    }
    return result;
}