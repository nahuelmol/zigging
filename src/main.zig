const std       = @import("std");

const commands = [_][]const u8{
    "l",
    "s",
    "d",
};

const Command = struct {
    name: []const u8,
};


pub fn worker(cmd:Command) !void {
    if (std.mem.eql(u8, cmd.name, "l")) {
        const cwd = std.fs.cwd();
        var dir = try cwd.openDir(".", .{ .iterate = true });
        defer dir.close();
        var it = dir.iterate();

        while (try it.next()) |entry| {
            std.debug.print("{s} ({any})\n", .{ entry.name, entry.kind });
        }
    } else {
        std.debug.print("\nworkgin\n", .{});
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var args = try std.process.argsWithAllocator(allocator);
    defer args.deinit();
    var found = false;

    var cmd: Command = undefined;
    _ = args.next();
    while (args.next()) |arg| {
        for (commands) |command| {
            if (std.mem.eql(u8, command, arg)) {
                found = true;
                std.debug.print("Command is available\n", .{});
                cmd.name = arg;
                break;
            }
        }
    } 
    if (found == false) {
        std.debug.print("Command is not available\n", .{});
        return;
    }
    try worker(cmd);

}
