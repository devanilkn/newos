bits 32

MULTIBOOT_MAGIC    equ 0x1BADB002
MULTIBOOT_FLAGS    equ 0x00000003  ; page-align modules + provide memory map
MULTIBOOT_CHECKSUM equ -(MULTIBOOT_MAGIC + MULTIBOOT_FLAGS)

section .multiboot
align 4
    dd MULTIBOOT_MAGIC
    dd MULTIBOOT_FLAGS
    dd MULTIBOOT_CHECKSUM

section .bss
align 16
stack_bottom:
    resb 16384          ; 16 KiB stack
stack_top:

section .note.GNU-stack noalloc noexec nowrite progbits

section .text
global _start
extern kmain

_start:
    mov esp, stack_top
    push ebx            ; multiboot info pointer
    push eax            ; multiboot magic
    call kmain
    cli
.halt:
    hlt
    jmp .halt
