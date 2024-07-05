/* 
 * File:   I2C.c
 * Author: Michael King
 * Hardware drivers for the I2C
 * Will enable I2C and it's associated interrupt
 * No output or interrupt is defined here, those need to be handled somewhere else.
 */

#include "I2C.h"

void I2C_init(void)
{
    // first set the SDA hold time, FM Plus enable defaults to zero
    TWI0.CTRLA |= TWI_SDAHOLD_500NS_gc;
    /* 
     * now set the baud rate (calculation in documentation) should result in
     * approximately 200khz tx frequency
     */
    TWI0.MBAUD = 51;
    //now enable the TWI as a host
    TWI0.MCTRLA |= TWI_ENABLE_bm | TWI_SMEN_bm; //enable host and smart mode
    //set the bus state to idle
    TWI0.MSTATUS |= TWI_BUSSTATE_IDLE_gc;
    //TWI should now be initialized and ready to use
}

#include <stdint.h>

uint16_t I2C_translate(uint8_t character)
{
    uint16_t result;  // Variable to hold the translated value
    
    switch (character)
    {
        case '0':
            result = 0xC3F;
            break;
        case '1':
            result = 0x406;
            break;
        case '2':
            result = 0xDB;
            break;
        case '3':
            result = 0x8F;
            break;
        case '4':
            result = 0xE6;
            break;
        case '5':
            result = 0xED;
            break;
        case '6':
            result = 0xFD;
            break;
        case '7':
            result = 0x1401;
            break;
        case '8':
            result = 0xFF;
            break;
        case '9':
            result = 0xE7;
            break;
        case 'A':
            result = 0xF7;
            break;
        case 'B':
            result = 0x128F;
            break;
        case 'C':
            result = 0x39;
            break;
        case 'D':
            result = 0x120F;
            break;
        case 'E':
            result = 0xF9;
            break;
        case 'F':
            result = 0xF1;
            break;
        case 'G':
            result = 0xBD;
            break;
        case 'H':
            result = 0xF6;
            break;
        case 'I':
            result = 0x1209;
            break;
        case 'J':
            result = 0x1E;
            break;
        case 'K':
            result = 0x2470;
            break;
        case 'L':
            result = 0x38;
            break;
        case 'M':
            result = 0x536;
            break;
        case 'N':
            result = 0x2136;
            break;
        case 'O':
            result = 0x3F;
            break;
        case 'P':
            result = 0xF3;
            break;
        case 'Q':
            result = 0x203F;
            break;
        case 'R':
            result = 0x20F3;
            break;
        case 'S':
            result = 0x18D;
            break;
        case 'T':
            result = 0x1201;
            break;
        case 'U':
            result = 0x3E;
            break;
        case 'V':
            result = 0xC30;
            break;
        case 'W':
            result = 0x2836;
            break;
        case 'X':
            result = 0x2D00;
            break;
        case 'Y':
            result = 0x1500;
            break;
        case 'Z':
            result = 0xC09;
            break;
        case 'a':
            result = 0xDF;
            break;
        case 'b':
            result = 0x2078;
            break;
        case 'c':
            result = 0xD8;
            break;
        case 'd':
            result = 0x88E;
            break;
        case 'e':
            result = 0x79;
            break;
        case 'f':
            result = 0x71;
            break;
        case 'g':
            result = 0x18F;
            break;
        case 'h':
            result = 0xF4;
            break;
        case 'i':
            result = 0x1000;
            break;
        case 'j':
            result = 0xE;
            break;
        case 'k':
            result = 0x3600;
            break;
        case 'l':
            result = 0x1200;
            break;
        case 'm':
            result = 0x10D4;
            break;
        case 'n':
            result = 0x2050;
            break;
        case 'o':
            result = 0xDC;
            break;
        case 'p':
            result = 0x471;
            break;
        case 'q':
            result = 0x20E3;
            break;
        case 'r':
            result = 0x50;
            break;
        case 's':
            result = 0x18D;
            break;
        case 't':
            result = 0x78;
            break;
        case 'u':
            result = 0x1C;
            break;
        case 'v':
            result = 0x810;
            break;
        case 'w':
            result = 0x2814;
            break;
        case 'x':
            result = 0x2D00;
            break;
        case 'y':
            result = 0x28E;
            break;
        case 'z':
            result = 0xC09;
            break;
        default:
            result = 0x8;
            break;
    }
    
    return result;
}