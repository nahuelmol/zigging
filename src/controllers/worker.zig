const std   = @import("std");
const Command = @import("..\\command.zig").Command;

pub fn Worker(cmd:Command) !void {
    var targetpath:[]const u8 = "";
    std.debug.print("\nroot:{s}\ntarget:{s}\ntypetarget:{s}\n", .{ cmd.root, cmd.target, cmd.typetarget });
    if (std.mem.eql(u8, cmd.root, "l")) {
        if(std.mem.eql(u8, cmd.target, "download") or std.mem.eql(u8, cmd.target, "d")){
            targetpath = "C:\\Users\\USUARIO\\Downloads";
        }
        const cwd   = std.fs.cwd();
        var dir     = try cwd.openDir(targetpath, .{ .iterate = true });
        defer dir.close();
        var it = dir.iterate();

        while (try it.next()) |entry| {
            if(std.mem.eql(u8, cmd.typetarget, "all")){
                std.debug.print("{s} ({any})\n", .{ entry.name, entry.kind });
            } else if(std.mem.eql(u8, cmd.typetarget, "P")){
                if(std.mem.eql(u8, entry.name[0..1], "P_")){
                    std.debug.print("{s}\n", .{ entry.name });
                }
            }
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
