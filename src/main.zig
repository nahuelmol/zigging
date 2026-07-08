const std       = @import("std");
//const display   = @import("controllers/utils.zig");
//const init      = @import("init.zig");
//const print     = @import("std").debug.print;
//const mem       = @import("std").mem;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var args = try std.process.argsWithAllocator(allocator);
    defer args.deinit();

    while (args.next()) |arg| {
        std.debug.print("{s}\n", .{arg});
    }
}
