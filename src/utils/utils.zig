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

    if(std.mem.eql(u8, opc, "o")){
        var buffer: [256]u8 = undefined;
        var stdin_reader = std.fs.File.stdin().reader(&buffer);
        const stdin = &stdin_reader.interface;
        const line = try stdin.takeDelimiterExclusive('\n');
        std.debug.print("input -> {s}\n", .{line});
    }

    defer allocator.free(data);
    var parsed = try std.json.parseFromSlice(
        std.json.Value,
        allocator,
        data,
        .{},
    );
    defer parsed.deinit();
}
