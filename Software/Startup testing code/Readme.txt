Startup testing:
By Michael King
February 24, 2024

Purpose:
The purpose of this startup testing is to gain familiarity with the process of initializing the AVR128DA28 chips we are using for our capstone project.

Objective:
1. successfully upload code to the AVR128DA28
2. successfully initialize the AVR128DA28's clock
3. initialize an I/O pin as an output and use it to drive an LED (marshal or button controller)
4. initialize an I/O pin as an input and use a button on the pin to drive the same LED (marshal or button controller)

This allows to test the most crucial functions of our devices

Procedure:
1. download microchip studio, and configure the correct target (AVR128DA28)
	- failed, Microchip (atmel) studio appears to have been discontinued, I will use MPLAB instead
2. review proper initialization steps from the atmel AVR-1000b document and datasheet:
	- I must configure the clock to be the internal high speed oscillator (should be default, but just making sure)
	- configure clock speed to 24MHz
3. Configure the I/O for one of the LED output pins:
	- enable correct peripheral clock (not needed on AVR chips?)
	- configure pin in correct port register
	- write to port output register
	I will use PD3 to start
This works.
4. Configure an I/O pin as an input
	- enable correct clock (not needed on AVR chips?)
	- configure pin in correct port register
	- check port input register(?)
	I will use PD4 to start
I will test this once I get a board