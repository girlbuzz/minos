const builtin = @import("builtin");

pub const cpu = switch (builtin.cpu.arch) {
    .x86 => @import("arch/x86/arch.zig"),
    else => @compileError("architecture is unsupported"),
};
