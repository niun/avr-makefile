avr-makefile
============

Makefile for building and flashing programs for Atmel AVR microcontrollers


Requirements
------------

* make
* avr-gcc (Debian/Ubuntu package `gcc-avr`)
* avr-libc (Debian/Ubuntu package `avr-libc`)
* binutils-avr (avr-size, avr-objcopy, avr-objdump, Debian/Ubuntu package `binutils-avr`)
* avrdude (Debian/Ubuntu package `avrdude`)


Targets
-------

* all: 	      Build everything.
* clean:      Delete build output.
* flash:      Upload .hex file to MCU.
* flashtest:  Simulate Uploading .hex file to MCU.
* fuseflash:  Write fuse values to MCU.
* fusetest:   Compare fuse settings with MCU fuses (no output when OK).

Setup
-----

* Put Makefile in project folder.
* Change config variables at top of Makefile.
* Optional: Setup a NOPASSWD directive for avrdude in your sudoers file:
  `user domain = (root) NOPASSWD: /usr/bin/avrdude`
