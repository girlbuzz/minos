const gdt = @import("gdt.zig");

comptime {
    const multiboot = @import("multiboot.zig");
    _ = multiboot;
}

fn init() void {
    gdt.initGDT();
}

pub fn outb(port: u16, byte: u8) void {
    asm volatile ("outb %[byte], %[port]"
        :
        : [port] "{dx}" (port),
          [byte] "{al}" (byte),
    );
}

pub fn outbMany(port: u16, bytes: []const u8) void {
    for (bytes) |byte| {
        outb(port, byte);
    }
}

pub fn hlt() noreturn {
    asm volatile ("hlt");
    unreachable;
}

export fn start() void {
    var magic: u32 = 69420;
    var ptr: u32 = 42069;

    asm volatile ("mov %%eax, %[magic]"
        : [magic] "=m" (magic),
    );

    asm volatile ("mov %%ebx, %[ptr]"
        : [ptr] "=m" (ptr),
    );

    init();
    @import("root").main();
}
