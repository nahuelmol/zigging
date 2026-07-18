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
    };

    pub fn init(self: *Model, ctx: *zz.Context) zz.Cmd(Msg) {
        std.debug.print("INIT MODEL\n", .{});
        var editor = zz.components.TextArea.init(ctx.allocator);
        editor.setSize(80, 24);
        editor.line_numbers = true;

        var list = zz.StyledList.init(ctx.allocator);
        list.setEnumerator(.roman);

        self.* = .{ 
            .count = 0, 
            .files = "",
            .editor = editor,
            .text = "",
            .list = list,
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
        }
        return .none;
    }

    pub fn view(self: *const Model, ctx: *const zz.Context) []const u8 {
        const style = (zz.Style{})
            .bold(true)
            .italic(true)
            .fg(.cyan());
        const list_text = self.list.items.items[0].text;
        const text = std.fmt.allocPrint(ctx.allocator, "Files:\n{s}\nCount: {d}\nList:{s}\nPress q to quit", 
            .{ self.text, self.count, list_text }) catch "Error";
        return style.render(ctx.allocator, text) catch text; 
    }

    pub fn example(self: *Model) !void {
        std.debug.print("EXAMPLE\n", .{});
        try self.list.addItem("First item");
        try self.list.addItem("Second item");
        try self.list.addItemNested("Sub-item", 1);
    }
};
