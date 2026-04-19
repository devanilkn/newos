#include <stdint.h>

#define VGA_BASE   ((volatile uint16_t *)0xB8000)
#define VGA_COLS   80
#define VGA_ROWS   25
#define VGA_ATTR   0x0F00   /* white on black */

#define SERIAL_PORT 0x3F8
#define KB_DATA     0x60
#define KB_STATUS   0x64

static inline uint8_t inb(uint16_t port) {
    uint8_t val;
    __asm__ volatile ("inb %1, %0" : "=a"(val) : "Nd"(port));
    return val;
}

static inline void outb(uint16_t port, uint8_t val) {
    __asm__ volatile ("outb %0, %1" :: "a"(val), "Nd"(port));
}

static void serial_init(void) {
    outb(SERIAL_PORT + 1, 0x00);  /* disable interrupts */
    outb(SERIAL_PORT + 3, 0x80);  /* enable DLAB */
    outb(SERIAL_PORT + 0, 0x03);  /* 38400 baud divisor lo */
    outb(SERIAL_PORT + 1, 0x00);  /* divisor hi */
    outb(SERIAL_PORT + 3, 0x03);  /* 8N1 */
    outb(SERIAL_PORT + 2, 0xC7);  /* enable FIFO */
}

static void serial_putc(char c) {
    while (!(inb(SERIAL_PORT + 5) & 0x20));
    outb(SERIAL_PORT, c);
}

static void serial_puts(const char *s) {
    for (; *s; s++) {
        if (*s == '\n') serial_putc('\r');
        serial_putc(*s);
    }
}

static void vga_clear(void) {
    for (int i = 0; i < VGA_COLS * VGA_ROWS; i++)
        VGA_BASE[i] = VGA_ATTR | ' ';
}

static void vga_puts(const char *s, int row, int col) {
    volatile uint16_t *ptr = VGA_BASE + row * VGA_COLS + col;
    for (; *s; s++, ptr++)
        *ptr = VGA_ATTR | (uint8_t)*s;
}

static void wait_for_keypress(void) {
    /* drain any pending key */
    while (inb(KB_STATUS) & 0x01)
        inb(KB_DATA);
    /* wait for a key-down event (scancode with bit 7 clear) */
    uint8_t sc;
    do {
        while (!(inb(KB_STATUS) & 0x01));
        sc = inb(KB_DATA);
    } while (sc & 0x80);
}

static void reboot(void) {
    /* pulse the CPU reset line via the PS/2 controller */
    while (inb(KB_STATUS) & 0x02);
    outb(KB_STATUS, 0xFE);
    /* should not reach here; halt as a fallback */
    __asm__ volatile ("cli; hlt");
}

void kmain(uint32_t magic, void *mbi) {
    (void)magic; (void)mbi;

    serial_init();
    vga_clear();

    const char *msg     = "Hello, newos!";
    const char *prompt  = "Press any key to restart...";

    vga_puts(msg,    11, (VGA_COLS - 13) / 2);
    vga_puts(prompt, 13, (VGA_COLS - 27) / 2);

    serial_puts(msg);
    serial_puts("\n");
    serial_puts(prompt);
    serial_puts("\n");

    wait_for_keypress();
    reboot();
}
