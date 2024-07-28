const std = @import("std");
const print = @import("std").debug.print;
const ascii = @import("std").ascii;

pub fn printer() void {
    const salud = "saluding";
    std.debug.print("hello {s}\n", .{salud});
}

pub fn checking_types() void {
    const example = "hello";
    const output = example[2];
    print("values -> {c}\n", .{example[2]});
    print("word: {}\n", .{@TypeOf(output)});
}
