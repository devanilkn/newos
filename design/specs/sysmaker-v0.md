# sysmaker v0 — Bootable USB Image Builder

**Status:** Accepted

## Context

Before building a real kernel, we need a working end-to-end pipeline that proves we can go from source code to a bootable USB image. Without this, there is no way to test that any kernel work actually runs on hardware.

The first milestone is a toy kernel (print "Hello, newos!", wait for a keypress, restart) built and packaged by sysmaker into an ISO image that can be written to a USB drive and booted on real x86 hardware.

## Decisions

### Bootloader: GRUB with Multiboot1

GRUB is the most widely-tested x86 bootloader and is available as a system package (`grub-pc-bin`). It implements the Multiboot1 specification, which defines a simple contract between bootloader and kernel:

- The kernel ELF binary contains a Multiboot header with a magic number and flags
- GRUB finds the header, loads the kernel into memory at its linked address, sets up a minimal 32-bit protected mode environment, and jumps to the kernel entry point
- The kernel receives a pointer to a Multiboot info struct (memory map, boot device, etc.)

Multiboot1 was chosen over Multiboot2 for simplicity. The toy kernel does not need the additional features Multiboot2 provides.

### Kernel target: 32-bit protected mode x86

GRUB's Multiboot handoff leaves the CPU in 32-bit protected mode with paging disabled. The toy kernel runs in this environment. Upgrading to 64-bit long mode is deferred to the real kernel.

### Kernel language: C + NASM assembly

- `boot.asm` (NASM) — Multiboot header, stack setup, entry point, jumps to `kmain`
- `kernel.c` (C, freestanding) — VGA text output, PS/2 keyboard input, system reset

This is sufficient for a toy. The real kernel will use Rust.

### Output format: ISO 9660

`grub-mkrescue` produces a hybrid ISO that is bootable from both optical media and USB. Writing the ISO to a USB drive with `dd` produces a bootable device. This is simpler than constructing a raw disk image with a partition table.

### sysmaker implementation: Makefile

The sysmaker for v0 is a GNU Makefile. It:
1. Builds the toy kernel (`kernel/toy/`) into an ELF binary
2. Stages GRUB configuration and the kernel binary
3. Calls `grub-mkrescue` to produce `newos.iso`

A Rust CLI tool is the intended long-term form of sysmaker; the Makefile is a v0 stepping stone.

### Testing: QEMU

QEMU (`qemu-system-x86_64`) boots the ISO without real hardware. The toy kernel writes output to both VGA memory and the serial port (0x3F8). QEMU captures serial output on stdout, allowing automated tests to verify the kernel booted and printed the expected text.

## Component layout

```
kernel/toy/
├── boot.asm       # Multiboot header + entry point
├── kernel.c       # kmain: VGA print, keyboard wait, reboot
├── linker.ld      # links kernel at 1MB (Multiboot convention)
├── Makefile       # produces kernel/toy/kernel.elf
└── tests/
    └── test_boot.sh   # boots ISO in QEMU, checks serial output

sysmaker/
├── Makefile           # top-level: builds kernel, stages files, calls grub-mkrescue
├── config/
│   └── grub.cfg       # GRUB menu entry pointing to kernel.elf
└── tests/
    └── test_image.sh  # validates ISO exists, has correct structure
```

## Consequences

- Establishes the full build → image → boot pipeline
- QEMU tests give confidence before writing to USB
- VGA + serial dual output keeps the kernel testable without a framebuffer
- 32-bit toy kernel is a dead end; the real kernel starts fresh in `kernel/src/`
- Dependency on GRUB means sysmaker v0 only targets x86 BIOS/CSM — UEFI support is future work
