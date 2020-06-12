.PHONY: clean
default: libnrf52832.a

# change these four if you aren't targetting an NRF52832
NRF_CPU = NRF52832_XXAA
SYSTEM_C = mdk/system_nrf52.c
ARCH_CPU = -mcpu=cortex-m4
STARTUP_S = mdk/gcc_startup_nrf52.S

# directory that has nrfx_glue.h, nrfx_config.h, and nrfx_log.h for your project
CONFIG_DIR = ../config
# director that has the cmsis headers
CMSIS_DIR = ../toolchain/cmsis/include

SRCFILES = $(wildcard drivers/src/*.c) soc/nrfx_atomic.c $(SYSTEM_C)
OBJS = $(patsubst  %.c,%.o,$(SRCFILES))

CC = arm-none-eabi-gcc
AR = arm-none-eabi-ar
CPP = arm-none-eabi-cpp
GAS = arm-none-eabi-as

INCL_DIRS = -I$(CONFIG_DIR) \
			-I. \
			-Imdk \
			-Idrivers \
			-Idrivers/include\
			-I$(CMSIS_DIR)

CFLAGS = -std=c99 -ggdb $(ARCH_CPU) -D$(NRF_CPU)

%.o: %.c
	$(CC) $(CFLAGS) $(INCL_DIRS) -o $@ -c $<

startup.o: $(STARTUP_S)
	$(CPP) $(STARTUP_S) | $(GAS) $(ARCH_CPU) -o startup.o

libnrf52832.a: $(OBJS) startup.o
	$(AR) rcs "$@" $(OBJS) startup.o

clean:
	find -name "*.o" | xargs rm
	rm -f libnrf52832.a
