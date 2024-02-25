Testing to ensure all basic I/O is sound.

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