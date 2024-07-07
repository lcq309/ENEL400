/* 
 * File:   I2C.c
 * Author: Michael King
 * Hardware drivers for the I2C
 * Will enable I2C and it's associated interrupt
 * No output or interrupt is defined here, those need to be handled somewhere else.
 */


#include <stdint.h>
#include "I2C.h"

#define CLK_PER                                         24000000     // 24MHz clock
#define TWI0_BAUD(F_SCL, T_RISE)                        ((((((float)CLK_PER / (float)F_SCL)) - 10 - ((float)CLK_PER * T_RISE))) / 2)
#define I2C_SCL_FREQ                                    100000

void I2C_init(void)
{
    //// first set the SDA hold time, FM Plus enable defaults to zero
    //TWI0.CTRLA |= TWI_SDAHOLD_500NS_gc;
    TWI0.MBAUD = (uint8_t)TWI0_BAUD(I2C_SCL_FREQ, 0);
    //now enable the TWI as a host
    TWI0.MCTRLA |= TWI_ENABLE_bm | TWI_SMEN_bm; //enable host and smart mode
    //set the bus state to idle
    TWI0.MSTATUS |= TWI_BUSSTATE_IDLE_gc;
    //TWI should now be initialized and ready to use
}

uint16_t I2C_translate(uint8_t character)
{
    uint16_t result;  // Variable to hold the translated value
    
    switch (character)
    {
        case '0':
            result = 0x003F;
            break;
        case '1':
            result = 0x1006;
            break;
        case '2':
            result = 0x055B;
            break;
        case '3':
            result = 0x053F;
            break;
        case '4':
            result = 0x0566;
            break;
        case '5':
            result = 0x056D;
            break;
        case '6':
            result = 0x057D;
            break;
        case '7':
            result = 0x5001;
            break;
        case '8':
            result = 0x057F;
            break;
        case '9':
            result = 0x0567;
            break;
        case 'A':
            result = 0x0577;
            break;
        case 'B':
            result = 0x4C0F;
            break;
        case 'C':
            result = 0x0039;
            break;
        case 'D':
            result = 0x480F;
            break;
        case 'E':
            result = 0x0579;
            break;
        case 'F':
            result = 0x0571;
            break;
        case 'G':
            result = 0x047D;
            break;
        case 'H':
            result = 0x0576;
            break;
        case 'I':
            result = 0x4809;
            break;
        case 'J':
            result = 0x001E;
            break;
        case 'K':
            result = 0x31C0;
            break;
        case 'L':
            result = 0x0038;
            break;
        case 'M':
            result = 0x12D6;
            break;
        case 'N':
            result = 0x22D6;
            break;
        case 'O':
            result = 0x003F;
            break;
        case 'P':
            result = 0x0573;
            break;
        case 'Q':
            result = 0x20FF;
            break;
        case 'R':
            result = 0x25B3;
            break;
        case 'S':
            result = 0x063D;
            break;
        case 'T':
            result = 0x4801;
            break;
        case 'U':
            result = 0x003E;
            break;
        case 'V':
            result = 0x9230;
            break;
        case 'W':
            result = 0xA2D6;
            break;
        case 'X':
            result = 0xB200;
            break;
        case 'Y':
            result = 0x5200;
            break;
        case 'Z':
            result = 0x9209;
            break;
        case 'a':
            result = 0x057F;
            break;
        case 'b':
            result = 0x21F0;
            break;
        case 'c':
            result = 0x0560;
            break;
        case 'd':
            result = 0x843E;
            break;
        case 'e':
            result = 0x0079;
            break;
        case 'f':
            result = 0x0071;
            break;
        case 'g':
            result = 0x063F;
            break;
        case 'h':
            result = 0x0574;
            break;
        case 'i':
            result = 0x4000;
            break;
        case 'j':
            result = 0x000E;
            break;
        case 'k':
            result = 0x7C00;
            break;
        case 'l':
            result = 0x4800;
            break;
        case 'm':
            result = 0x4554;
            break;
        case 'n':
            result = 0x2140;
            break;
        case 'o':
            result = 0x057C;
            break;
        case 'p':
            result = 0x11C1;
            break;
        case 'q':
            result = 0x25C3;
            break;
        case 'r':
            result = 0x0050;
            break;
        case 's':
            result = 0x063D;
            break;
        case 't':
            result = 0x0078;
            break;
        case 'u':
            result = 0x001C;
            break;
        case 'v':
            result = 0x8010;
            break;
        case 'w':
            result = 0xA014;
            break;
        case 'x':
            result = 0xB200;
            break;
        case 'y':
            result = 0x0C0E;
            break;
        case 'z':
            result = 0x9209;
            break;
        default:
            result = 0xffff;
            break;
    }
    
    return result;
}