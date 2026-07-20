const std       = @import("std");
const utils     = @import("utils\\utils.zig");

const commands = [_][]const u8{
    "l",
    "s",
    "d",
    "set",
    "cpf",
    "see",
};

pub const Command = struct {
    allocator: std.mem.Allocator,
    root: []const u8,
    target: []const u8,
    typetarget: ?[]u8,
    all: bool,

    pub fn init(self: *Command, allocator: std.mem.Allocator) void {
        self.allocator = allocator;
        self.root = "";
        self.target = "";
        self.typetarget = null;
        self.all = false;
    }

    pub fn deinit(self: *Command) void {
        self.allocator.free(self.root);
        if (self.target.len != 1 or self.target[0] != '.') {
            self.allocator.free(self.target);
        }

        if (self.typetarget) |tt| {
            self.allocator.free(tt);
        }
    }

    pub fn set(self: *Command) !void {
        var args = try std.process.argsWithAllocator(self.allocator);
        const argv = try std.process.argsAlloc(self.allocator);
        defer args.deinit();
        defer std.process.argsFree(self.allocator, argv);

        var found = false;

        _ = args.next();
        const nargs = argv.len - 1;

        if (argv.len > 1) {
            const root = args.next() orelse return error.MissingCommand;
            for (commands) |command| {
                if (std.mem.eql(u8, command, root)) {
                    found = true;
                    self.root = try self.allocator.dupe(u8, root);
                    break;
                }
            }
        } else {
            std.debug.print("not command inserted", .{});
            return;
        }
        if (found == true) {
            if (std.mem.eql(u8, "l", self.root)) {
                if (nargs > 1){
                    self.target = try self.allocator.dupe(u8, argv[2]);
                    if (nargs > 2){
                        self.typetarget = try self.allocator.dupe(u8, argv[3]);
                    } else {
                        self.typetarget = try self.allocator.dupe(u8, "all");
                    }
                } else {
                    self.target = ".";
                }
            } else if (std.mem.eql(u8, "cpf", self.root)) {
                if (nargs > 1){
                    self.target = try self.allocator.dupe(u8, argv[2]);
                    if (nargs > 2){
                        self.typetarget = try self.allocator.dupe(u8, argv[3]);
                    } else {
                        self.typetarget = try self.allocator.dupe(u8, "all");
                    }
                } else {
                    self.target = ".";
                }
            } else if (std.mem.eql(u8, "d", self.root)) {
                std.debug.print("setting for d command", .{});
            } else if (std.mem.eql(u8, "see", self.root)) {
                if (nargs > 1){
                    self.target = try self.allocator.dupe(u8, argv[2]);
                    if (nargs > 2){
                        self.typetarget = try self.allocator.dupe(u8, argv[3]);
                    } else {
                        self.typetarget = try self.allocator.dupe(u8, "all");
                    }
                } else {
                    self.target = ".";
                    self.all = true;
                }
            } else if (std.mem.eql(u8, "sv", self.root)) {
                std.debug.print("setting for s command", .{});
            } else if (std.mem.eql(u8, "set", self.root)) {
                if (nargs > 1){
                    self.target = try self.allocator.dupe(u8, argv[2]);
                } else {
                    self.target = try self.allocator.dupe(u8, ".");
                }
            } else {
                std.debug.print("unrecognized root", .{});
            }
        } else { 
            std.debug.print("Command is not available\n", .{});
            return;
        }
    }
};
