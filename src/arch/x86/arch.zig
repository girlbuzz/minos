const gdt = @import("gdt.zig");

comptime {
    const multiboot = @import("multiboot.zig");
    _ = multiboot;
}

fn init() void {
    gdt.initGDT();
}

pub fn hlt() noreturn {
    asm volatile ("hlt");
    unreachable;
}

export fn start() void {
    var magic: u32 = undefined;
    var ptr: u32 = undefined;

    asm volatile ("mov %%eax, %[magic]"
        : [magic] "=r" (magic),
    );

    asm volatile ("mov %%ebx, %[ptr]"
        : [ptr] "=r" (ptr),
    );

    if (magic != 0xe85250d6) {
        @panic("magic number is incorrect.");
    }

    init();
    @import("root").main();
    @panic("`main` returned.");
}
