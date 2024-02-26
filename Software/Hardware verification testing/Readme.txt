Testing to ensure all basic I/O is sound. (Michael King)

Testing includes:
- simple test of Button module (buttons controls lights)
inputs: PD6, PD5, PD3, PD2, PC3 (active low)
outputs: PC1, PC0, PA7
- simple test of Marshal Controller (indicators respond to buttons)
inputs: PD4, PD5, PD6 (active low)
outputs: PD3, PD1, PC3, PC0
- simple test of Light driver (cycle through colours of light)
outputs: PC2, PC3, PD0, PD1

All code in main, for the final software build the overall initialization will be contained within one function for each type of device.
With additional functions for turning outputs on and off.

inputs will be controlled primarily through interrupts, so there isn't much point in making normal functions for them.

Testing Round 2:
February 25, 2024 (Michael King)
- create a driver for the Lap counter shift registers
	G controls output, and is active low.
	SRCK controls the input shift register
	RCK controls the storage output register
	CLR clears buffers, and is active low.
	SER IN is the input data

	SRCK (CLK2) needs to pulse once per bit, data transfers on the rising edge so the serial should be switched before the clock

- create a test for the lap counter controller
	Basically, I'll have the buttons control the display
	I will need to create a driver for the I2C for the display

	first, I need to initialize the TWI on the AVR chip

	Steps to initialize TWI:
	1. first configure the SDA hold time and FM Plus Enable bits in the Control A register.
	Initialize as a host:
	Write the Host Baud Rate (TWI0.MBAUD) registers to a value that results in a valid bus clock frequency. Writing a '1' to the Enable
	TWI host bit will enable the host. The bus state field in the host status register must be set to 0x1 to force the bus to Idle.

	The display doesn't need to work especially fast, so I will use the 500NS hold time to start, I will set up the baud rate for a frequency of 200kHz
	FMPEN should be zero as we are not using FM+

	to calculate the baud field value:
	BAUD = (f_cpu / (2 x f_scl)) - (5 + ((f_cpu x t_r)/2)
	rise time will be taken as 0.3 us from the display datasheet.
	so
	BAUD = (24MHz / (2 x 200k)) - (5 +((24Mhz x 0.3us)/2)
	BAUD = 60 - 8.6
	BAUD = 51.4
	BAUD = ~51

	Steps to send a message on TWI:
	1. START
	2. Send Address, set read or write bit
	3. wait for ACK
	4. send message, wait for ACK between bytes
	5. after finished, send STOP

	The I2C drivers do not make use of interrupts yet, and may need modification to work properly when implemented in an RTOS task.
	
	Steps to receive a message on TWI:
	1. START
	2. Send Address, set write bit
	3. wait for ACK
	4. send command or register address
	5. wait for ACK
	6. STOP and START
	7. send Address again, set read bit
	8. receive byte, send ACK between, send NACK after last byte
	9. STOP

	Steps to initialize the display:
	1. enable clock
	2. set output pins and output level
	3. set dimming
	4. set blinking
	