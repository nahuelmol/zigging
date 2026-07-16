const std = @import("std");
const Command   = @import(".\\..\\command.zig").Command;

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
        if(std.mem.eql(u8, origin_copy, ".")) {
            var pathbuffer: [std.fs.max_path_bytes]u8 = undefined;
            const path = try std.process.getCwd(&pathbuffer);
            const path_copy = try allocator.dupe(u8, path);
            try obj.put("origin", .{ .string = path_copy });
        } else {
            try obj.put("origin", .{ .string = origin_copy });
        }
    } else if(std.mem.eql(u8, opc, "d")){
        var buffer: [256]u8 = undefined;
        var stdin_reader = std.fs.File.stdin().reader(&buffer);
        const stdin = &stdin_reader.interface;
        const origin = try stdin.takeDelimiterExclusive('\n');
        const clean_origin = std.mem.trimRight(u8, origin, "\r");
        const origin_copy = try allocator.dupe(u8, clean_origin);
        if(std.mem.eql(u8, origin_copy, ".")) {
            var pathbuffer: [std.fs.max_path_bytes]u8 = undefined;
            const cwd = try std.process.getCwd(&pathbuffer);
            const cwd_copy = try allocator.dupe(u8, cwd);
            try obj.put("download", .{ .string = cwd_copy });
        } else {
            try obj.put("download", .{ .string = origin_copy });
        }
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

pub fn takeManifest(field:[]const u8) ![]const u8 {
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
    const obj = parsed.value.object;
    if (obj.get(field)) |value| {
        return try allocator.dupe(u8, value.string);
    } else {
        return "not path";
    }
}

pub fn Copyfrom(cmd:Command) !void {

    var targetpath:[]const u8 = "";
    if(std.mem.eql(u8, cmd.typetarget.?, "d")){
        targetpath = "C:\\Users\\USUARIO\\Downloads";
    } else if(std.mem.eql(u8, cmd.typetarget.?, "t")){
        targetpath = "C:\\Users\\USUARIO\\trabajo";
    }

    const cwd   = std.fs.cwd();
    var dir     = try cwd.openDir(targetpath, .{ .iterate = true });
    defer dir.close();
    var it = dir.iterate();

    const originpath = try takeManifest("origin");
    while (try it.next()) |entry| {
        if(std.mem.eql(u8, cmd.target, "all")){
            std.debug.print("copying.. {s}\n", .{ entry.name });
        } else if(std.mem.eql(u8, cmd.target, "P")){
            if(std.mem.eql(u8, entry.name[0..2], "P ")){
                std.debug.print("copying..{s}\n", .{ entry.name });
                const allocator = std.heap.page_allocator;
                const result = try std.fmt.allocPrint(
                    allocator,
                    "{s}\\{s}",
                    .{ targetpath, entry.name },
                );
                defer allocator.free(result);
                const newfilepath = try std.fmt.allocPrint(
                    allocator,
                    "{s}\\{s}",
                    .{ originpath, entry.name },
                );
                defer allocator.free(newfilepath);

                try cwd.copyFile(
                    result,
                    cwd,
                    newfilepath,
                    .{},
                );
            }
        } else if(std.mem.eql(u8, cmd.target, "DC")){
            if(std.mem.eql(u8, entry.name[0..3], "DC ")){
                std.debug.print("copying..{s}\n", .{ entry.name });
                const allocator = std.heap.page_allocator;
                const result = try std.fmt.allocPrint(
                    allocator,
                    "{s}\\{s}",
                    .{ targetpath, entry.name },
                );
                defer allocator.free(result);
                const newfilepath = try std.fmt.allocPrint(
                    allocator,
                    "{s}\\{s}",
                    .{ originpath, entry.name },
                );
                defer allocator.free(newfilepath);

                try cwd.copyFile(
                    result,
                    cwd,
                    newfilepath,
                    .{},
                );
            }
        } else {
            std.debug.print("not recognized target\n", .{});
        }
    }
}
