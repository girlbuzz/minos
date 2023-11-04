ARCH=x86

ifeq ($(ARCH),x86)
GRUBFLAGS+=-d /usr/lib/grub/i386-pc
endif

.PHONY: all kernel clean run

all: minos.iso

kernel: zig-out/bin/kernel.elf

zig-out/bin/kernel.elf:
	zig build $(ZIGFLAGS) -Darch=$(ARCH)

iso/boot/kernel.elf: zig-out/bin/kernel.elf
	cp zig-out/bin/kernel.elf $@

minos.iso: iso/boot/kernel.elf
	grub-mkrescue $(GRUBFLAGS) iso -o $@

run: minos.iso
	qemu-system-$(ARCH) $(QEMUFLAGS) -cdrom minos.iso

clean:
	rm -rf iso/boot/kernel.elf minos.iso zig-out/ zig-cache/
