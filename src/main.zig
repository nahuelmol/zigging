const std       = @import("std");
const worker    = @import("controllers\\worker.zig");
const Command   = @import("command.zig").Command;


pub fn main() !void {
    var cmd: Command = undefined;

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    cmd.init(allocator);
    defer cmd.deinit();

    try cmd.set();
    try worker.Worker(cmd);
}
