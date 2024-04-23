/* 
 * RS 485 Sector Controller
 * Author:  Michael King
 * 
 * Created on April 22, 2024
 * 
 * This is meant to be a generic Sector Light controller on the wired network
 * which means that it has 3 buttons (Blue, Yellow, Green) and controls 
 * a sector light with either 3 or 4 colours.
 */

#include <stdio.h>
#include <stdlib.h>
#include <DSIO.h>
#include <RS485TASKS.h>
#include "USART.h"
#include <avr/io.h>
#include <avr/interrupt.h>
#include "FreeRTOS.h"
#include "task.h"
#include "semphr.h"
#include "event_groups.h"
#include "stream_buffer.h"
#include "message_buffer.h"
#include "ShiftReg.h"

/*
 * 
 */
int main(int argc, char** argv) {

    return (EXIT_SUCCESS);
}

