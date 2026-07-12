const std   = @import("std");
const Command = @import("..\\command.zig").Command;

pub fn Worker(cmd:Command) !void {
    var targetpath:[]const u8 = "";
    if (std.mem.eql(u8, cmd.root, "l")) {
        if(std.mem.eql(u8, cmd.target, "download") or std.mem.eql(u8, cmd.target, "d")){
            targetpath = "C:\\Users\\USUARIO\\Downloads";
        }
        const cwd = std.fs.cwd();
        var dir = try cwd.openDir(targetpath, .{ .iterate = true });
        defer dir.close();
        var it = dir.iterate();

        while (try it.next()) |entry| {
            std.debug.print("{s} ({any})\n", .{ entry.name, entry.kind });
        }
        std.debug.print("looking at {s}\n", .{cmd.target});
    } else if (std.mem.eql(u8, cmd.root, "s")){
        std.debug.print("saving file in db", .{});
        //catch @panic("some error");
    } else if (std.mem.eql(u8, cmd.root, "d")){
        std.debug.print("idk", .{});
        //catch @panic("some error");
    } else {
        std.debug.print("\nworking\n", .{});
    }
}
