const cpu = @import("arch.zig").cpu;
const std = @import("std");
const builtin = std.builtin;

pub fn panic(string: []const u8, st: ?*builtin.StackTrace, sz: ?usize) noreturn {
    _ = sz;
    _ = st;
    _ = string;
    cpu.hlt();
}
