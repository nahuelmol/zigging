const Command   = @import("..\\command.zig").Command;
const utils     = @import("..\\utils\\utils.zig");
const std       = @import("std");
const zpdf      = @import("zpdf");

pub fn readPDF(cmd:Command) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const originpath = try utils.takeManifest("origin");
    const cwd   = std.fs.cwd();
    var dir     = try cwd.openDir(originpath, .{ .iterate = true });
    defer dir.close();
    var it = dir.iterate();

    std.debug.print("{s}", .{cmd.target});

    while (try it.next()) |entry| {
        if(entry.kind == .file) {
            const filepath = try std.fs.path.join(allocator, &.{ originpath, entry.name });
            defer allocator.free(filepath);
            const doc = try zpdf.Document.open(allocator, filepath);
            defer doc.close();

            var buf: [4096]u8 = undefined;
            var bw = std.fs.File.stdout().writer(&buf);
            const writer = &bw.interface;
            defer writer.flush() catch {};

            for (0..doc.pageCount()) |page_num| {
                try doc.extractText(page_num, writer);
            }
        }
    }
}

