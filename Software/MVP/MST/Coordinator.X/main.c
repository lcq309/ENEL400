/* 
 * File:   main.c - Coordinator
 * Author: Michael King
 * MVP version
 *
 * The purpose of this is to create a minimum viable coordinator running code, 
 * to start, this needs at least the RS485 read and write tasks, as well as the
 * round robin task to drive the wired network. Then we can begin testing other
 * wired modules as well.
 * Created on March 15, 2024, 8:49 AM
 */

#include <stdio.h>
#include <stdlib.h>
#include "USART.h"
#include <avr/io.h>
#include "FreeRTOS.h" 

/*
 *
 */
int main(int argc, char** argv) {
    //first set the clock
    _PROTECTED_WRITE(CLKCTRL.OSCHFCTRLA, CLKCTRL.OSCHFCTRLA | CLKCTRL_FRQSEL_24M_gc);
    //enable USART0 (RS485 USART)
    USART0_init();
    
    return (EXIT_SUCCESS);
}

