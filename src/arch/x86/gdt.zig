pub const GDTEntry = packed struct {
    limit_lo: u16,
    base_lo: u16,
    base_hi_lo: u8,
    access: u8,
    limit_hi: u4,
    flags: u4,
    base_hi_hi: u8,

    fn new(base: u32, limit: u20, access: u8, flags: u4) GDTEntry {
        return .{
            .base_lo = base & 0xFFFF,
            .base_hi_lo = base & 0xFF0000 >> 8,
            .base_hi_hi = base & 0xFF000000 >> 16,

            .limit_lo = limit & 0xFFFF,
            .limit_hi = limit & 0xF0000 >> 16,

            .access = access,
            .flags = flags,
        };
    }
};

pub const gdt = [5]GDTEntry{
    GDTEntry.new(0, 0, 0, 0),
    GDTEntry.new(0, 0xFFFFF, 0x9A, 0xC),
    GDTEntry.new(0, 0xFFFFF, 0x92, 0xC),
    GDTEntry.new(0, 0xFFFFF, 0xFA, 0xC),
    GDTEntry.new(0, 0xFFFFF, 0xF2, 0xC),
};

comptime {
    // TODO: This is horrible.
    asm (
        \\gdtr:
        \\     .word 0
        \\     .long 0
        \\
        \\setGdt:
        \\  mov 4(%esp), %ax
        \\  mov %ax, (gdtr)
        \\  mov 8(%esp), %eax
        \\.intel_syntax noprefix
        \\  mov [gdtr + 2], eax
        \\.att_syntax prefix
        \\  lgdt (gdtr)
        \\  ret
        \\
        \\reloadSegments:
        \\  jmp $0x08,$.reload_CS
        \\.reload_CS:
        \\  mov $0x10, %ax
        \\  mov %ax, %ds
        \\  mov %ax, %es
        \\  mov %ax, %fs
        \\  mov %ax, %gs
        \\  mov %ax, %ss
        \\  ret
    );
}

pub extern fn setGdt(limit: i16, base: u32) void;
pub extern fn reloadSegments() void;
