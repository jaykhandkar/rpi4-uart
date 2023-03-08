ARMGNU ?= aarch64-linux-gnu

CFLAGS = -Wall -nostdlib -nostartfiles -ffreestanding -I. -mgeneral-regs-only -DPRINTF_DISABLE_SUPPORT_FLOAT
ASMFLAGS = -I.
CFILES = $(wildcard *.c)
OBJFILES = $(CFILES:.c=.o)

all: kernel8.img

clean:
	rm -f *.img *.o *.elf

startup_64.o: startup_64.S
	$(ARMGNU)-gcc $(ASMFLAGS) -c startup_64.S -o startup_64.o

%.o: %.c
	$(ARMGNU)-gcc $(CFLAGS) -c $< -o $@

kernel8.img: startup_64.o $(OBJFILES)
	$(ARMGNU)-ld -nostdlib startup_64.o $(OBJFILES) -T linker.ld -o kernel8.elf
	$(ARMGNU)-objcopy -O binary kernel8.elf kernel8.img
