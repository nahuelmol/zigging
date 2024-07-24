const std       = @import("std");
const display   = @import("controllers/example.zig");
const init      = @import("init.zig");
const print     = @import("std").debug.print;

pub fn main() !void {
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

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

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
