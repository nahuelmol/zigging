const std       = @import("std");

const commands = [_][]const u8{
    "l",
    "s",
    "d",
};

pub const Command = struct {
    allocator: std.mem.Allocator,
    root: []const u8,
    target: []const u8,

    pub fn init(self: *Command, allocator: std.mem.Allocator) void {
        self.allocator = allocator;
        self.root = "";
        self.target = "";
    }

    pub fn deinit(self: *Command) void {
        self.allocator.free(self.root);

        if (self.target.len != 0 and !std.mem.eql(u8, self.target, ".")) {
            self.allocator.free(self.target);
        }
    }

    pub fn set(self: *Command) !void {
        var args = try std.process.argsWithAllocator(self.allocator);
        const argv = try std.process.argsAlloc(self.allocator);
        defer args.deinit();
        defer std.process.argsFree(self.allocator, argv);

        var found = false;
        var i:usize =   1;

        _ = args.next();
        const nargs = argv.len - 1;
        const root = args.next() orelse return error.MissingCommand;

        for (commands) |command| {
            if (std.mem.eql(u8, command, root)) {
                found = true;
                std.debug.print("Root found\n", .{});
                self.root = try self.allocator.dupe(u8, root);
                break;
            }
        }
        i+=1;
        if (found == true) {
            if (std.mem.eql(u8, "l", self.root)) {
                if (nargs > (i+1)){
                    self.target = argv[i+1];
                } else {
                    self.target = ".";
                }
            } else if (std.mem.eql(u8, "d", self.root)) {
                std.debug.print("setting for d command", .{});
            } else {
                std.debug.print("unrecognized root", .{});
            }
        } else { 
            std.debug.print("Command is not available\n", .{});
            return;
        }
        std.debug.print("setting up command\n root {s} ", .{self.root});
    }
};
