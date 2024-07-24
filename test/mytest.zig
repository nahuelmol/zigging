const testing = @import("std").testing;
const example = @import("../controllers/example.zig");

test newword {
    try example.printer();
    try testing.expect(newword(33) == 1);
}

fn newword(num: u32) u32 {
    const rester = num - 1;
    const result = num - rester;

    return result;
}
