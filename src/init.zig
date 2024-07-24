const std       = @import("std");
const stdout    = std.io.getStdOut().writer();
const print     = @import("std").debug.print;

pub fn take_fw(prove:[]const u8) ![]u8 {
    var index:usize = 0;
    const limit:usize = prove.len;

    const allocator = std.heap.page_allocator;
    const buffer = try allocator.alloc(u8, limit);

    while (index < limit){
        if (prove[index] == ' ')  {
            break;
        }
        buffer[index]= prove[index];
        index+=1;
    }

    const newbuffer = try allocator.alloc(u8, index);
    var i:usize = 0;
    while(i < index){
        newbuffer[i] = buffer[i];
        i+=1;
    }
    allocator.free(buffer);
    return newbuffer;
}

pub fn take_first_w(prove:[]const u8) !void {
    var index:usize = 0;
    const limit:usize = prove.len;
    const word = "";

    while (index < limit){
        if (prove[index] == ' ')  {
            return;
        }
        const mychar = prove[index];
        const newword = word ++ &[_]u8{mychar};
        print("{c}", .{newword});
        index+=1;
    }
}


fn print_all(prove:[]const u8) !void {
    //var fword:[]u8 = undefined;
    print("{s}\n", .{prove});
}

fn itera_string(prove:[]const u8) !void {
    var index: usize = 0;
    while (index < prove.len){
        try stdout.print("the char is: {c}\n", .{prove[index]});
        index+=1;
    }
}

