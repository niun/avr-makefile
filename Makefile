# This is a Makefile Template for Atmel AVR microcontroller projects.
# See README.md for requirements.
#
# The author is not employed at Atmel or in any way affiliated with Atmel.


# Name prefix for the output files:
RESULT_NAME = avr_project_name

# Output directory:
OUTDIR = output

# Name of target architecture (as used by avr-gcc, avr-size, avrdude):
TARGET = atmega164p

# MCU CPU frequency (in Hz):
F_CPU = 8000000

# MCU Fuse settings:
HFUSE = 0x99
LFUSE = 0x46
EFUSE = 0xFF

# avrdude programmer config:
PROGRAMMER = avrispmkII 
PROGRAMMER_PORT = usb 

# Compiler command:
COMPILER = avr-gcc


# Complete output file prefix:
OUTFILE = $(OUTDIR)/$(RESULT_NAME)

# Compiler / Linker settings:
TARGET_SETTINGS = -mmcu=$(TARGET) -DF_CPU=$(F_CPU)UL
LANGUAGE_SETTINGS = -std=gnu99 -fgnu89-inline
OPTIMIZATION_SETTINGS = -funsigned-char -funsigned-bitfields -Os -ffunction-sections -fdata-sections -fpack-struct -fshort-enums 
DEBUG_SETTINGS = -gdwarf-2

COMPILE = $(COMPILER) -c -Wall $(TARGET_SETTINGS) $(LANGUAGE_SETTINGS) $(OPTIMIZATION_SETTINGS) $(DEBUG_SETTINGS)
LINK = $(COMPILER) -Wl,-Map=$(OUTDIR)/$(RESULT_NAME).map -Wl,--start-group  -Wl,--end-group -Wl,--gc-sections -mmcu=$(TARGET)



.PHONY: all clean pre-build post-build main-build target flash fuseflash fusetest

# Targets
# =======
#
# Use only these ones on the command line:
# all: 	      Build everything.
# clean:      Delete build output.
# flash:      Upload .hex file to MCU.
# flashtest:  Simulate Uploading .hex file to MCU.
# fuseflash:  Write fuse values to MCU.
# fusetest:   Compare fuse settings with MCU fuses (no output when OK).

all: post-build 
	
pre-build: 
	mkdir -p $(OUTDIR)

post-build: main-build
	avr-size -C --mcu=$(TARGET) "$(OUTFILE).elf"
	@echo DONE

main-build: pre-build
	@$(MAKE) --no-print-directory target

target: $(OUTFILE).hex $(OUTFILE).eep $(OUTFILE).lss $(OUTFILE).srec

$(OUTFILE).hex: $(OUTFILE).elf
	avr-objcopy -O ihex -R .eeprom -R .fuse -R .lock -R .signature $< $@

$(OUTFILE).eep: $(OUTFILE).elf
	avr-objcopy -j .eeprom  --set-section-flags=.eeprom=alloc,load --change-section-lma .eeprom=0  --no-change-warnings -O ihex "$(OUTFILE).elf" "$(OUTFILE).eep" || exit 0

$(OUTFILE).lss: $(OUTFILE).elf
	avr-objdump -h -S "$(OUTFILE).elf" > "$(OUTFILE).lss"

$(OUTFILE).srec: $(OUTFILE).elf
	avr-objcopy -O srec -R .eeprom -R .fuse -R .lock -R .signature  "$(OUTFILE).elf" "$(OUTFILE).srec"

MOD_OBJS = $(OUTDIR)/usart_camstrg.o
OBJS = $(OUTDIR)/main.o $(MOD_OBJS)


$(OUTFILE).elf: $(OBJS)
	$(LINK) -o $@ $(OBJS)

$(OUTDIR)/main.o: main.c
	$(COMPILE) -o $@ $<

$(MOD_OBJS): $(OUTDIR)/%.o: %.c %.h
	$(COMPILE) -o $@ $<
# Generates for every MOD_OBJ ==>
# $(OUTDIR)/usart_camstrg.o: usart_camstrg.c usart_camstrg.h
#   	$(COMPILE) -o $@ usart_camstrg.c usart_camstrg.h

clean: 
	rm $(OBJS)
	rm $(OUTFILE).elf
	rm $(OUTFILE).map
	rm $(OUTFILE).hex
	rm $(OUTFILE).eep
	rm $(OUTFILE).lss
	rm $(OUTFILE).srec

flash:
	sudo avrdude -p $(TARGET) -P $(PROGRAMMER_PORT) -c $(PROGRAMMER) -U flash:w:$(OUTDIR)/$(RESULT_NAME).hex:a

fuseflash:
	sudo avrdude -p $(TARGET) -P $(PROGRAMMER_PORT) -c $(PROGRAMMER) -u -U lfuse:w:$(LFUSE):m -U hfuse:w:$(HFUSE):m -U efuse:w:$(EFUSE):m

fusetest:
	sudo avrdude -p $(TARGET) -P $(PROGRAMMER_PORT) -c $(PROGRAMMER) -q -q -u -U lfuse:v:$(LFUSE):m -U hfuse:v:$(HFUSE):m -U efuse:v:$(EFUSE):m

flashtest:
	sudo avrdude -n -p $(TARGET) -P $(PROGRAMMER_PORT) -c $(PROGRAMMER) -U flash:w:$(OUTDIR)/$(RESULT_NAME).hex:a

