const std       = @import("std");
const display   = @import("controllers/utils.zig");
const init      = @import("init.zig");
const print     = @import("std").debug.print;

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});
    try bw.flush();

    display.printer();
    display.checking_types();
    try init.take_first_w("hello world");
    const result = try init.take_fw("hello world");
    print("buffer: {s}\n", .{result});
}

