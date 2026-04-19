REPO_ROOT  := $(shell cd .. && pwd)
KERNEL_DIR := $(REPO_ROOT)/kernel/toy
KERNEL_ELF := $(KERNEL_DIR)/kernel.elf
ISO_STAGE  := $(CURDIR)/isoroot
ISO_OUT    := $(CURDIR)/newos.iso

GRUB_MKRESCUE := grub-mkrescue

.PHONY: all kernel iso clean test check-deps

all: check-deps kernel iso

check-deps:
	@for tool in nasm gcc ld grub-mkrescue xorriso; do \
	    command -v $$tool >/dev/null 2>&1 || { \
	        echo "Missing: $$tool"; \
	        echo "Install with: sudo apt-get install nasm gcc grub-pc-bin grub-common xorriso"; \
	        exit 1; \
	    }; \
	done

kernel:
	$(MAKE) -C $(KERNEL_DIR)

iso: $(KERNEL_ELF)
	rm -rf $(ISO_STAGE)
	mkdir -p $(ISO_STAGE)/boot/grub
	cp $(KERNEL_ELF)          $(ISO_STAGE)/boot/kernel.elf
	cp config/grub.cfg         $(ISO_STAGE)/boot/grub/grub.cfg
	$(GRUB_MKRESCUE) -o $(ISO_OUT) $(ISO_STAGE) 2>/dev/null
	@echo "Built: $(ISO_OUT)"
	@echo "Write to USB: sudo dd if=$(ISO_OUT) of=/dev/sdX bs=4M status=progress && sync"

clean:
	$(MAKE) -C $(KERNEL_DIR) clean
	rm -rf $(ISO_STAGE) $(ISO_OUT)

test: all
	@bash tests/test_image.sh
	@bash $(KERNEL_DIR)/tests/test_boot.sh
