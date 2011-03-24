# File to be included in all makefiles

#OR32_TOOL_PREFIX=/home/wallento/or32.tmp/bin/or32-elf
OR32_TOOL_PREFIX=or32-elf

#GCC_LIB_OPTS=-mor32-newlib -mor32-newlib-uart
GCC_LIB_OPTS=-nostartfiles 

GCC_OPT=-mhard-mul -g -Wall -O2 -fno-strict-aliasing

FLASH_MEM_HEX_FILE_SUFFIX=-twobyte-sizefirst
SRAM_MEM_HEX_FILE_SUFFIX=-fourbyte

# Global clean rule
clean:
	@echo "Cleaning `pwd`"
	@rm -f *.o *.or32 *.log *.bin *.srec *.hex *.log stdout.txt *.vmem *.asm *.a stdout.txt *.dis *.mem

