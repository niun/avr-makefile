avr-makefile
============

Makefile for building and flashing programs for Atmel AVR microcontrollers


Requirements
------------

* avr-gcc
* binutils-avr (avr-size, avr-objcopy, avr-objdump)
* avrdude


Targets
-------

* all: 	      Build everything.
* clean:      Delete build output.
* flash:      Upload .hex file to MCU.
* flashtest:  Simulate Uploading .hex file to MCU.
* fuseflash:  Write fuse values to MCU.
* fusetest:   Compare fuse settings with MCU fuses (no output when OK).


