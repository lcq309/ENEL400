/* 
 * File:   USART.c
 * Author: Michael King
 * Hardware drivers for USARTs, may need to be modified on a board by board
 * basis to ensure the correct USARTs are targeted.
 * Will enable the targeted USART with interrupts enabled, as well as global
 * interrupts
 */

#include "USART.h"

void USART0_init(void)
{
    //start by disabling global interrupts (if they are enabled)
    SREG &= ~CPU_I_bm; //set interrupt enable to zero to disable global interrupts
    //Calculate baud rate
    USART0.BAUD = ((64 * (long int)CPU_F)/(16*(long int)USARTBAUD)); //calculate baud rate and set
    USART0.CTRLC = USART_CMODE_ASYNCHRONOUS_gc | USART_CHSIZE_8BIT_gc | \
            USART_PMODE_EVEN_gc; //set asynch, 8bit frames, even parity
    //note that parity mode may need to be changed for certain vendor devices
    //Set tx pin as an output
    PORTA.DIRSET = PIN0_bm; //port A pin 0 is txd for USART 0
    // set interrupt RXCIE, DREIF is enabled in code before moving to the register
    USART0.CTRLA = USART_RXCIE_bm;
    //enable the receiver and transmitter
    USART0.CTRLB = USART_RXEN_bm | USART_TXEN_bm;
    //re-enable global interrupts
    SREG |= ~CPU_I_bm;
    //USART0 now initialized for 8bit, even parity, interrupt driven mode
}