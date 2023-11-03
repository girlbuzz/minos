// make public so that these can easily be accessed from other
// parts of the codebase with a @import("root")
pub const cpu = @import("arch.zig").cpu;
pub const panic = @import("panic.zig").panic;

comptime {
    // zig is lazy so in order to ensure `start` gets exported
    // i have to make sure it gets evaluated
    _ = cpu;
}

const vgamem: [*]u8 = @ptrFromInt(0xb8000);

pub fn main() void {
    vgamem[0] = 'H';
    vgamem[1] = 0b01110000;
    vgamem[2] = 'i';
    vgamem[3] = 0b01110000;
}
