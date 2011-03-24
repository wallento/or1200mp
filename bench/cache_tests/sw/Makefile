include support/Makefile.inc

all: main.mem main.dis

main.bin: main.or32
	$(OR32_TOOL_PREFIX)-objcopy -O binary main.or32 main.bin

main.or32: main.o
	$(OR32_TOOL_PREFIX)-gcc ${GCC_LIB_OPTS} -o main.or32 -T support/linker.ld support/reset.o support/except.o main.o support/libsupport.a
	
main.o: main.c
	$(OR32_TOOL_PREFIX)-gcc $(GCC_OPT) -Isupport/ -O2 -o main.o -c main.c

main.mem: main.bin
	bin2mem main.bin > main.mem

main.dis: main.or32
	$(OR32_TOOL_PREFIX)-objdump -d main.or32 > main.dis
