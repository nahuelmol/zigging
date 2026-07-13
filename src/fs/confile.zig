const std       = @import("std");

pub const File = struct {
    allocator: std.mem.Allocator,
    content: []const u8,
};
