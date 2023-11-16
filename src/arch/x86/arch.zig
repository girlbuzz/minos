const gdt = @import("gdt.zig");

comptime {
    const multiboot = @import("multiboot.zig");
    _ = multiboot;
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
    asm volatile ("cli");

    gdt.setGdt(@sizeOf(@TypeOf(gdt.gdt)) - 1, @intFromPtr(&gdt.gdt));
    gdt.reloadSegments();

    @import("root").main();
    hlt();
}
