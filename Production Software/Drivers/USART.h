/* 
 * File:   USART.h
 * Author: Michael King
 * Hardware drivers for USARTs, may need to be modified on a board by board
 * basis to ensure the correct USARTs are targeted.
 * Will enable the targeted USART with interrupts enabled, as well as global
 * interrupts.
 * Assumes that the CPU is running at 24MHZ
 * Created on March 15, 2024, 8:58 AM
 */

#ifndef USART_H
#define	USART_H
#include <stdio.h>
#include <stdlib.h>
#include <avr/io.h>
#include <avr/interrupt.h>

#define CPU_F 24000000 //24MHz

#ifdef	__cplusplus
extern "C" {
#endif
    
/* BAUDRATE variables
 * set these before calling the initialization
 * they have a default of 115200
 */
    extern uint32_t USART0BAUD;
    extern uint32_t USART1BAUD;
    extern uint32_t USART2BAUD;
    
    
/* USART0_init
 * Initializes USART0 to run with interrupts enabled, interrupts will need to be
 * setup depending on which device type it is. (interrupt driven tasks will be
 * part of common code shared by all boards)
 */
    void USART0_init(void);
    
/* USART1_init
 * Initializes USART1
 */

    void USART1_init(void);
    
/* USART2_init
 * Initializes USART2
 */
    void USART2_init(void);
#ifdef	__cplusplus
}
#endif

#endif	/* USART_H */

