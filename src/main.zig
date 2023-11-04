// make public so that these can easily be accessed from other
// parts of the codebase with a @import("root")
pub const cpu = @import("arch.zig").cpu;
pub const panic = @import("panic.zig").panic;

const serial = @import("drivers/serial.zig");

comptime {
    // zig is lazy so in order to ensure `start` gets exported
    // i have to make sure it gets evaluated
    _ = cpu;
}

pub fn main() noreturn {
    const writer = serial.getCom1();

    try writer.print("Hello, {s}!\n", .{"minos"});

    cpu.hlt();
}
