.PHONY: clean
default: libnrf52832.a

# change these four if you aren't targetting an NRF52832
NRF_CPU = NRF52832_XXAA
SYSTEM_C = mdk/system_nrf52.c
ARCH_CPU = -mcpu=cortex-m4
STARTUP_S = mdk/gcc_startup_nrf52.S

# directory that has nrfx_glue.h, nrfx_config.h, and nrfx_log.h for your project
CONFIG_DIR = ../config
CONFIGS = $(CONFIG_DIR)/nrfx_config.h $(CONFIG_DIR)/nrfx_log.h $(CONFIG_DIR)/nrfx_glue.h
# directory that has the cmsis headers
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

%.o: %.c $(CONFIGS)
	$(CC) $(CFLAGS) $(INCL_DIRS) -o $@ -c $<

startup.o: $(STARTUP_S)
	$(CPP) $(STARTUP_S) | $(GAS) $(ARCH_CPU) -o startup.o

libnrf52832.a: startup.o $(OBJS) $(CONFIGS)
	$(AR) rcs "$@" $(OBJS)

clean:
	find -name "*.o" | xargs rm
	rm -f libnrf52832.a
