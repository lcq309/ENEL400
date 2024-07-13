/* 
 * File:   USART.c
 * Author: Michael King
 * Hardware drivers for USARTs, may need to be modified on a board by board
 * basis to ensure the correct USARTs are targeted.
 * Will enable the targeted USART with interrupts enabled, as well as global
 * interrupts
 */

#include "USART.h"

uint32_t USART0BAUD = 115200;
uint32_t USART1BAUD = 115200;
uint32_t USART2BAUD = 115200;

void USART0_init(void)
{
    //start by disabling global interrupts (if they are enabled)
    SREG &= ~CPU_I_bm; //set interrupt enable to zero to disable global interrupts
    //Calculate baud rate
    USART0.BAUD = (double)((64 * (double)CPU_F)/(16 * (double)USART0BAUD)); //calculate baud rate and set
    USART0.CTRLC = USART_CMODE_ASYNCHRONOUS_gc | USART_CHSIZE_8BIT_gc | \
            USART_PMODE_EVEN_gc; //set asynch, 8bit frames, even parity
    USART0.CTRLC &= ~USART_SBMODE_bm; //ensure single stop bit is set
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

void USART1_init(void)
{
    //start by disabling global interrupts (if they are enabled)
    SREG &= ~CPU_I_bm; //set interrupt enable to zero to disable global interrupts
    //Calculate baud rate
    USART1.BAUD = (double)((64 * (double)CPU_F)/(16 * (double)USART1BAUD));; //calculate baud rate and set
    USART1.CTRLC = USART_CMODE_ASYNCHRONOUS_gc | USART_CHSIZE_8BIT_gc | \
            USART_PMODE_EVEN_gc; //set asynch, 8bit frames, even parity
    //note that parity mode may need to be changed for certain vendor devices
    //Set tx pin as an output
    PORTC.DIRSET = PIN0_bm; //port C pin 0 is txd for USART 0
    // set interrupt RXCIE, DREIF is enabled in code before moving to the register
    USART1.CTRLA = USART_RXCIE_bm;
    //enable the receiver and transmitter
    USART1.CTRLB = USART_RXEN_bm | USART_TXEN_bm;
    //re-enable global interrupts
    SREG |= ~CPU_I_bm;
    //USART1 now initialized for 8bit, even parity, interrupt driven mode
}

void USART2_init(void)
{
    //start by disabling global interrupts (if they are enabled)
    SREG &= ~CPU_I_bm; //set interrupt enable to zero to disable global interrupts
    //Calculate baud rate
    USART2.BAUD = (double)((64 * (double)CPU_F)/(16 * (double)USART2BAUD));; //calculate baud rate and set
    USART2.CTRLC = USART_CMODE_ASYNCHRONOUS_gc | USART_CHSIZE_8BIT_gc | \
            USART_PMODE_EVEN_gc; //set asynch, 8bit frames, even parity
    //note that parity mode may need to be changed for certain vendor devices
    //Set tx pin as an output
    PORTF.DIRSET = PIN0_bm; //port F pin 0 is txd for USART 0
    // set interrupt RXCIE, DREIF is enabled in code before moving to the register
    USART2.CTRLA = USART_RXCIE_bm;
    //enable the receiver and transmitter
    USART2.CTRLB = USART_RXEN_bm | USART_TXEN_bm;
    //re-enable global interrupts
    SREG |= ~CPU_I_bm;
    //USART1 now initialized for 8bit, even parity, interrupt driven mode
}