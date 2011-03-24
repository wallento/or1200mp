include Makefile.inc

all: libsupport.a

libsupport.a: support.o int.o except.o syscall.o vfnprintf.o stubs.o time.o uart.o mutex.o vfnprintf.o multicore.o reset.o
	$(OR32_TOOL_PREFIX)-ar cru libsupport.a $^
	$(OR32_TOOL_PREFIX)-ranlib libsupport.a

# A generic rule for c
%.o: %.c
	$(OR32_TOOL_PREFIX)-gcc $(GCC_OPT) -O2 -c -o $@ $?
# A generic rule for assembly files
%.o: %.S
	$(OR32_TOOL_PREFIX)-gcc $(GCC_OPT) -O2 -c -o $@ $?


#all: libsupport-nocache.a libsupport-ic.a libsupport-icdc.a libsupport-dc.a
#
#libsupport-nocache.a: support.o int.o except.o syscall.o vfnprintf.o stubs.o time.o uart.o mutex.o vfnprintf.o multicore.o reset-nocache.o
#	$(OR32_TOOL_PREFIX)-ar cru libsupport-nocache.a $^
#	$(OR32_TOOL_PREFIX)-ranlib libsupport-nocache.a
#
#libsupport-ic.a: support.o int.o except.o syscall.o vfnprintf.o stubs.o uart.o time.o mutex.o vfnprintf.o multicore.o reset-ic.o
#	$(OR32_TOOL_PREFIX)-ar cru libsupport-ic.a $^
#	$(OR32_TOOL_PREFIX)-ranlib libsupport-ic.a
#
#libsupport-icdc.a: support.o int.o except.o syscall.o vfnprintf.o stubs.o uart.o time.o mutex.o vfnprintf.o multicore.o reset-icdc.o
#	$(OR32_TOOL_PREFIX)-ar cru libsupport-icdc.a $^
#	$(OR32_TOOL_PREFIX)-ranlib libsupport-icdc.a
#
#libsupport-dc.a: support.o int.o except.o syscall.o vfnprintf.o stubs.o uart.o time.o mutex.o vfnprintf.o multicore.o reset-dc.o
#	$(OR32_TOOL_PREFIX)-ar cru libsupport-dc.a $^
#	$(OR32_TOOL_PREFIX)-ranlib libsupport-dc.a
#

# Rules for each specific reset type we want
#reset-nocache.o: reset.S
#	$(OR32_TOOL_PREFIX)-gcc $(GCC_OPT) -O2 -c -DIC=0 -DDC=0 -o $@ $?
#
#reset-dc.o: reset.S
#	$(OR32_TOOL_PREFIX)-gcc $(GCC_OPT) -O2 -c -DIC=0 -DDC=1 -o $@ $?
#
#reset-ic.o: reset.S
#	$(OR32_TOOL_PREFIX)-gcc $(GCC_OPT) -O2 -c -DIC=1 -DDC=0 -o $@ $?
#
#reset-icdc.o: reset.S
#	$(OR32_TOOL_PREFIX)-gcc $(GCC_OPT) -O2 -c -DIC=1 -DDC=1 -o $@ $?

