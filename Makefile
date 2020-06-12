.PHONY: clean
default: libnrf52832.a

# change these three if you aren't targetting an NRF52832
NRF_CPU = NRF52832_XXAA
SYSTEM_C = mdk/system_nrf52.c
ARCH_CPU = -mcpu=cortex-m4

# directory that has nrfx_glue.h, nrfx_config.h, and nrfx_log.h for your project
CONFIG_DIR = ../config
# director that has the cmsis headers
CMSIS_DIR = ../toolchain/cmsis/include

SRCFILES = $(wildcard drivers/src/*.c) soc/nrfx_atomic.c $(SYSTEM_C)
OBJS = $(patsubst  %.c,%.o,$(SRCFILES))

CC = arm-none-eabi-gcc
AR = arm-none-eabi-ar

INCL_DIRS = -I$(CONFIG_DIR) \
			-I. \
			-Imdk \
			-Idrivers \
			-Idrivers/include\
			-I$(CMSIS_DIR)

CFLAGS = -std=c99 -ggdb $(ARCH_CPU) -D$(NRF_CPU)

%.o: %.c
	$(CC) $(CFLAGS) $(INCL_DIRS) -o $@ -c $<

libnrf52832.a: $(OBJS)
	$(AR) rcs "$@" $(OBJS)

clean:
	find -name "*.o" | xargs rm
	rm libnrf52832.a
