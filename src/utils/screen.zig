const std   = @import("std");
const zz    = @import("zigzag");

pub const Model = struct {
    count: i32,
    files: []const u8,
    text: []const u8,
    editor: zz.components.TextArea,
    list: zz.StyledList,

    pub const Msg = union(enum) {
        key: zz.KeyEvent,
        text: []const u8,
    };

    pub fn init(self: *Model, ctx: *zz.Context) zz.Cmd(Msg) {
        std.debug.print("INIT MODEL\n", .{});

        var editor = zz.components.TextArea.init(ctx.allocator);
        editor.setSize(80, 24);
        editor.line_numbers = true;


        self.* = .{ 
            .count = 0, 
            .files = "",
            .editor = editor,
            .text = "",
            .list = self.list,
        };

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
            .text => |text| {
                std.debug.print("{s}", .{text});
            },
        }
        return .none;
    }

    pub fn view(self: *const Model, ctx: *const zz.Context) []const u8 {
        const style = (zz.Style{})
            .bold(true)
            .italic(true)
            .fg(.cyan());

        var list_text = std.ArrayList(u8){};
        for (self.list.items.items) |item| {
            list_text.appendSlice(ctx.allocator, item.text) catch {};
            list_text.append(ctx.allocator, '\n') catch {};
        }

        const text = std.fmt.allocPrint(ctx.allocator, "Files:\n{s}\nCount: {d}\nList:\n{s}\nPress q to quit", 
            .{ self.text, self.count, list_text.items }) catch "Error";
        return style.render(ctx.allocator, text) catch text; 
    }

    pub fn example(self: *Model, ctx: *zz.Context, text:[]const u8) !void {
        const msg = Msg{ .text = text };
        _ = self.update(msg, ctx);
    }
};
