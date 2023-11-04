const cpu = @import("arch.zig").cpu;
const std = @import("std");
const serial = @import("drivers/serial.zig");
const builtin = std.builtin;

pub fn panic(string: []const u8, st: ?*builtin.StackTrace, sz: ?usize) noreturn {
    _ = sz;
    _ = st;

    const writer = serial.getCom1();

    try writer.print("Kernel panic! {s}\n", .{string});

    cpu.hlt();
}
