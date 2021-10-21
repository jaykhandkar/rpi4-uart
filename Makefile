ARMGNU ?= aarch64-linux-gnu

CFLAGS = -Wall -nostdlib -nostartfiles -ffreestanding -I. -mgeneral-regs-only
ASMFLAGS = -I.
CFILES = $(wildcard *.c)
OBJFILES = $(CFILES:.c=.o)

all: kernel8.img

clean:
	rm -f *.img *.o *.elf

entry.o: entry.S
	$(ARMGNU)-gcc $(ASMFLAGS) -c entry.S -o entry.o

%.o: %.c
	$(ARMGNU)-gcc $(CFLAGS) -c $< -o $@

kernel8.img: entry.o $(OBJFILES)
	$(ARMGNU)-ld -nostdlib entry.o $(OBJFILES) -T linker.ld -o kernel8.elf
	$(ARMGNU)-objcopy -O binary kernel8.elf kernel8.img
