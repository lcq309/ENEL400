This is where the device specific code is, this is also where you go to build and program a device. Initialization code is somewhat device specific, so it will also be in here.
Most modular tasks will need to be released by the initialization task before they are able to start running, this makes use of an event group.
xEventInit is the event group that must be set by the initialization task to wake the modular tasks.

Anything within these projects should be linked only to other things within the Production Software folder, to make it convenient to use.

Within each folder: 
there needs to be a FreeRTOSConfig.h
a DSIO.h and DSIO.c (Device Specific IO)
the main.c for the device
DSIO defines any IO interrupts (except those defined in communications)