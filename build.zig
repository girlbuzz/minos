const std = @import("std");
const Builder = std.build.Builder;
const Target = std.Target;
const CrossTarget = std.zig.CrossTarget;

pub fn build(b: *Builder) void {
    const cpu = b.option(Target.Cpu.Arch, "arch", "the cpu architecture to build the kernel for");

    var model: CrossTarget.CpuModel = .native;

    if (cpu) |c| {
        model = .{ .explicit = Target.Cpu.Model.generic(c) };
    }

    const target: CrossTarget = .{
        .cpu_arch = cpu,
	.cpu_model = model,
        .ofmt = .elf,
        .os_tag = .freestanding,
        .abi = .none
    };

    const optimize = b.standardOptimizeOption(.{});

    const kernel = b.addExecutable(.{
        .name = "kernel.elf",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    kernel.setLinkerScript(.{ .path = "src/linker.ld" });
    kernel.code_model = .kernel;

    b.installArtifact(kernel);
}
