const std       = @import("std");
const worker    = @import("controllers\\worker.zig");
const Command   = @import("command.zig").Command;

const commands = [_][]const u8{
    "l",
    "s",
    "d",
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var args = try std.process.argsWithAllocator(allocator);
    const argv = try std.process.argsAlloc(allocator);
    defer args.deinit();
    defer std.process.argsFree(allocator, argv);

    var found = false;
    var i:usize =   1;

    var cmd: Command = undefined;
    _ = args.next();
    const nargs = argv.len - 1;

    while (args.next()) |arg| {
        for (commands) |command| {
            if (std.mem.eql(u8, command, arg)) {
                found = true;
                std.debug.print("Command is available\n", .{});
                cmd.name = arg;
                std.debug.print("nargs: {}\ni: {}\n", .{nargs, i});
                if (argv.len > (i+1)){
                    cmd.dir = argv[i+1];
                } else {
                    cmd.dir = ".";
                }
                break;
            }
        }
        i+=1;
    } 
    if (found == false) {
        std.debug.print("Command is not available\n", .{});
        return;
    }
    try worker.worker(cmd);

}
