CC      = gcc
AS      = nasm
LD      = ld

CFLAGS  = -m32 -ffreestanding -fno-stack-protector -fno-pie -nostdlib \
          -Wall -Wextra -std=c11 -O2
ASFLAGS = -f elf32
LDFLAGS = -m elf_i386 -T linker.ld --oformat elf32-i386 -nostdlib

OBJ = boot.o kernel.o

.PHONY: all clean test

all: kernel.elf

kernel.elf: $(OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

boot.o: boot.asm
	$(AS) $(ASFLAGS) -o $@ $<

kernel.o: kernel.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f *.o kernel.elf

test:
	@bash tests/test_boot.sh
