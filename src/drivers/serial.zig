const std = @import("std");
const cpu = @import("root").cpu;

pub const SerialError = error{};

fn serialWrite(port: u16, bytes: []const u8) SerialError!usize {
    cpu.outbMany(port, bytes);
    return bytes.len;
}

pub const SerialDevice = std.io.Writer(u16, SerialError, serialWrite);

pub fn getCom1() SerialDevice {
    return .{ .context = 0x3f8 };
}
