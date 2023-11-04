const GDTEntry = packed struct {
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

const gdt = [_]GDTEntry{
    GDTEntry.new(0, 0, 0, 0),
    GDTEntry.new(0, 0xFFFFF, 0x9A, 0xC),
    GDTEntry.new(0, 0xFFFFF, 0x92, 0xC),
    GDTEntry.new(0, 0xFFFFF, 0xFA, 0xC),
    GDTEntry.new(0, 0xFFFFF, 0xF2, 0xC),
};

const GDTDescriptor = packed struct {
    size: u16,
    offset: [*]const GDTEntry,
};

const gdtd = GDTDescriptor{
    .size = @sizeOf(@TypeOf(gdt)) - 1,
    .offset = &gdt,
};

comptime {
    asm (
        \\reloadSegments:
        \\     push %ebp
        \\     mov %esp, %ebp
        \\     mov $0x08, %eax
        \\     push %eax
        \\     push .reload_cs
        \\     lret
        \\.reload_cs:
        \\      mov $0x10, %ax
        \\      mov %ax, %ds
        \\      mov %ax, %es
        \\      mov %ax, %fs
        \\      mov %ax, %gs
        \\      mov %ax, %ss
        \\      mov %ebp, %esp
        \\      pop %ebp
        \\      ret
    );
}

extern fn reloadSegments() void;

fn loadGDT(g: *const GDTDescriptor) void {
    asm volatile ("lgdt %[g]"
        :
        : [g] "m" (g),
    );

    reloadSegments();
}

pub fn initGDT() void {
    loadGDT(&gdtd);
}
