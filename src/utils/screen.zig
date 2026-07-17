const std   = @import("std");
const zz    = @import("zigzag");

pub const Model = struct {
    count: i32,
    files: "",

    pub const Msg = union(enum) {
        key: zz.KeyEvent,
    };

    pub fn init(self: *Model, _: *zz.Context) zz.Cmd(Msg) {
        self.* = .{ .count = 0 };
        return .none;
    }

    pub fn update(self: *Model, msg: Msg, _: *zz.Context) zz.Cmd(Msg) {
        switch (msg) {
            .key => |k| switch (k.key) {
                .char => |c| if (c == 'q') return .quit,
                .up => self.count += 1,
                .down => self.count -= 1,
                else => {},
            },
        }
        return .none;
    }

    pub fn view(self: *const Model, ctx: *const zz.Context) []const u8 {
        const style = (zz.Style{})
            .bold(true)
            .italic(true)
            .fg(.cyan());

        const text = std.fmt.allocPrint(ctx.allocator, "Files:\n{s}\nCount: {d}\n\nPress q to quit", .{ self.files,self.count}) catch "Error";
        return style.render(ctx.allocator, text) catch text;
    }
};
