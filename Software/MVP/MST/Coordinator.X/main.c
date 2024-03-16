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
/* Version one: RS485 only
 * The purpose of this is to provide a testbed for the RS485 network,
 * it uses just the round robin to drive the wired network, no other tasks are
 * implemented.
 */
#include <stdio.h>
#include <stdlib.h>
#include "USART.h"
#include <avr/io.h>
#include <avr/interrupt.h>
#include "FreeRTOS.h"

/* Setting up variables for streams and tasks
 */

int main(int argc, char** argv) {
    //clock is set by FreeRTOS
    //enable USART0 (RS485 USART)
    USART0_init();
    
    return (EXIT_SUCCESS);
}

