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
        case ' ': return 0x00;
        case '0': return 0xC3F;
        case '1': return 0x406;
        case '2': return 0xDB;
        case '3': return 0x8F;
        case '4': return 0xE6;
        case '5': return 0xED;
        case '6': return 0xFD;
        case '7': return 0x1401;
        case '8': return 0xFF;
        case '9': return 0xE7;
        case 'A': return 0xF7;
        case 'B': return 0x128F;
        case 'C': return 0x39;
        case 'D': return 0x120F;
        case 'E': return 0xF9;
        case 'F': return 0xF1;
        case 'G': return 0xBD;
        case 'H': return 0xF6;
        case 'I': return 0x1209;
        case 'J': return 0x1E;
        case 'K': return 0x2470;
        case 'L': return 0x38;
        case 'M': return 0x536;
        case 'N': return 0x2136;
        case 'O': return 0x3F;
        case 'P': return 0xF3;
        case 'Q': return 0x203F;
        case 'R': return 0x20F3;
        case 'S': return 0x18D;
        case 'T': return 0x1201;
        case 'U': return 0x3E;
        case 'V': return 0xC30;
        case 'W': return 0x2836;
        case 'X': return 0x2D00;
        case 'Y': return 0x1500;
        case 'Z': return 0xC09;
        case 'a': return 0xDF;
        case 'b': return 0x2078;
        case 'c': return 0xD8;
        case 'd': return 0x88E;
        case 'e': return 0x79;
        case 'f': return 0x71;
        case 'g': return 0x18F;
        case 'h': return 0xF4;
        case 'i': return 0x1000;
        case 'j': return 0xE;
        case 'k': return 0x3600;
        case 'l': return 0x1200;
        case 'm': return 0x10D4;
        case 'n': return 0x2050;
        case 'o': return 0xDC;
        case 'p': return 0x471;
        case 'q': return 0x20E3;
        case 'r': return 0x50;
        case 's': return 0x18D;
        case 't': return 0x78;
        case 'u': return 0x1C;
        case 'v': return 0x810;
        case 'w': return 0x2814;
        case 'x': return 0x2D00;
        case 'y': return 0x28E;
        case 'z': return 0xC09;
        default:  return 0xffff;
    }
    
    return result;
}