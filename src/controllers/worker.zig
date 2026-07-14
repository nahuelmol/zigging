const std   = @import("std");
const Command = @import("..\\command.zig").Command;
const utils     = @import("..\\utils\\utils.zig");
const File      = @import("..\\fs\\confile.zig").File;

pub fn Worker(cmd:Command) !void {
    var targetpath:[]const u8 = "";
    if (std.mem.eql(u8, cmd.root, "l")) {
        if(std.mem.eql(u8, cmd.target, "download") or std.mem.eql(u8, cmd.target, "d")){
            targetpath = "C:\\Users\\USUARIO\\Downloads";
        } else if(std.mem.eql(u8, cmd.target, "trabajo") or std.mem.eql(u8, cmd.target, "t")){
            targetpath = "C:\\Users\\USUARIO\\trabajo";
        } else {
            targetpath = ".";
        }
        const cwd   = std.fs.cwd();
        var dir     = try cwd.openDir(targetpath, .{ .iterate = true });
        defer dir.close();
        var it = dir.iterate();

        while (try it.next()) |entry| {
            if(std.mem.eql(u8, cmd.typetarget.?, "all")){
                std.debug.print("{s} ({any})\n", .{ entry.name, entry.kind });
            } else if(std.mem.eql(u8, cmd.typetarget.?, "P")){
                if(std.mem.eql(u8, entry.name[0..2], "P ")){
                    std.debug.print("{s}\n", .{ entry.name });
                }
            } else if(std.mem.eql(u8, cmd.typetarget.?, "DC")){
                if(std.mem.eql(u8, entry.name[0..3], "DC ")){
                    std.debug.print("{s}\n", .{ entry.name });
                }
            } else {
                std.debug.print("not recognized target\n", .{});
            }
        }
    } else if (std.mem.eql(u8, cmd.root, "s")){
        std.debug.print("saving file in db", .{});
    } else if (std.mem.eql(u8, cmd.root, "set")){
        if (utils.doExists("manifest.json") == false){
            const file = try std.fs.cwd().createFile("manifest.json", .{});
            defer file.close();
            try file.writeAll("{\n\"origin\": \"\"\n}");
        }
        try utils.setManifest(cmd.target);
    } else if (std.mem.eql(u8, cmd.root, "d")){
        std.debug.print("deleting something", .{});
    } else {
        std.debug.print("\nworking\n", .{});
    }
}
