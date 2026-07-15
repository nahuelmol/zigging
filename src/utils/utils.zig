const std = @import("std");

pub fn doExists(filepath:[]const u8) bool {
    _ = std.fs.cwd().openFile(filepath, .{}) catch |err| {
        if (err == error.FileNotFound) {
            std.debug.print("{s} does not exist\n", .{filepath});
            return false;
        }
        return true;
    };
    return false;
}

pub fn setManifest(opc:[]const u8) !void {
    const allocator = std.heap.page_allocator;
    const file = try std.fs.cwd().openFile("manifest.json", .{});
    defer file.close();
    const data = try file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(data);

    var parsed = try std.json.parseFromSlice(
        std.json.Value,
        allocator,
        data,
        .{},
    );
    defer parsed.deinit();

    var obj = parsed.value.object;
    if(std.mem.eql(u8, opc, "o")){
        var buffer: [256]u8 = undefined;
        var stdin_reader = std.fs.File.stdin().reader(&buffer);
        const stdin = &stdin_reader.interface;
        const origin = try stdin.takeDelimiterExclusive('\n');
        const clean_origin = std.mem.trimRight(u8, origin, "\r");
        const origin_copy = try allocator.dupe(u8, clean_origin);
        try obj.put("origin", .{ .string = origin_copy });
    }

    const out = try std.fs.cwd().createFile("manifest.json", .{
        .truncate = true,
    });
    defer out.close();

    var out_writer = out.writer(&.{});
    var stringifier = std.json.Stringify{
        .writer = &out_writer.interface,
        .options = .{
            .whitespace = .indent_2,
        },
    };

    try stringifier.write(parsed.value);
}
