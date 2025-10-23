const std = @import("std");

pub fn build(b: *std.Build) void {
    const upstream = b.dependency("hdrhistogram_c", .{});
    const lib = b.addLibrary(.{
        .name = "hdrhistogram_c",
        .linkage = .static,
        .root_module = b.createModule(.{
            .target = b.standardTargetOptions(.{}),
            .optimize = b.standardOptimizeOption(.{}),
            .link_libc = true,
        }),
    });
    lib.addCSourceFiles(.{
        .root = upstream.path("src"),
        .files = &.{
            "hdr_writer_reader_phaser.c",
            "hdr_time.c",
            "hdr_thread.c",
            "hdr_interval_recorder.c",
            "hdr_histogram_log_no_op.c",
            // "hdr_histogram_log.c", // TODO: depends on zlib depencency
            "hdr_histogram.c",
            "hdr_encoding.c",
        },
    });
    lib.addIncludePath(upstream.path("include"));
    lib.installHeadersDirectory(upstream.path("include"), "", .{
        .include_extensions = &.{
            "hdr_histogram.h",
            "hdr_histogram_version.h",
        },
    });
    b.installArtifact(lib);
}
