const std       = @import("std");
const display   = @import("controllers/utils.zig");
const init      = @import("init.zig");
const print     = @import("std").debug.print;
const mem       = @import("std").mem;

pub fn main() void {
    
    std.debug.print("hello, world", .{});
    const bytes = "gellow";
    print("\n{}\n", .{@TypeOf(bytes)});

    var x: u32 = undefined;
    var y: u32 = undefined;
    var z: u32 = undefined;
    const vector: @Vector(3, u32) = .{7, 8, 9};

    x, y, z = vector;
    const a: u32 = 44;
    const b: u32 = 55;

    // print("x = {}, y = {}, z = {}", .{x, y, z});

    const result = if (a != b) 47 else 3089;
    print("result -> {}  ", .{result});
}

