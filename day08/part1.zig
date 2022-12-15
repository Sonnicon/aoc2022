// zig is not fun

const std = @import("std");
const WIDTH = 99;

pub fn main() !void {
    const file = try std.fs.cwd().openFile("input.txt", .{ .read = true });
    defer file.close();
    var reader = std.io.bufferedReader(file.reader());
    var stream = reader.reader();

    var data: [WIDTH * WIDTH]u8 = std.mem.zeroes([WIDTH * WIDTH]u8);
    var index: u32 = 0;
    while (index < WIDTH * WIDTH) {
        var char: u8 = stream.readByte() catch break;
        if (char != '\n') {
            data[index] = char + 1;
            index += 1;
        }
    }

    var tree_visibility: [WIDTH * WIDTH]bool = std.mem.zeroes([WIDTH * WIDTH]bool);
    var i: u32 = 0;
    var left: u8 = undefined;
    var top: u8 = undefined;
    var right: u8 = undefined;
    var bottom: u8 = undefined;

    while (i < WIDTH * WIDTH) {
        if (i % WIDTH == 0) {
            left = 0;
            top = 0;
            right = 0;
            bottom = 0;
        }
        // Left to right
        var mapped_index: u32 = i;
        if (data[mapped_index] > left) {
            left = data[mapped_index];
            tree_visibility[mapped_index] = true;
        }
        // Right to left
        mapped_index = WIDTH * WIDTH - i - 1;
        if (data[mapped_index] > right) {
            right = data[mapped_index];
            tree_visibility[mapped_index] = true;
        }
        // Top to bottom
        mapped_index = WIDTH * (i % WIDTH) + (i / WIDTH);
        if (data[mapped_index] > top) {
            top = data[mapped_index];
            tree_visibility[mapped_index] = true;
        }
        // Bottom to dop
        mapped_index = WIDTH * WIDTH - mapped_index - 1;
        if (data[mapped_index] > bottom) {
            bottom = data[mapped_index];
            tree_visibility[mapped_index] = true;
        }
        i += 1;
    }

    var result: u32 = 0;
    for (tree_visibility) |visible| {
        if (visible) {
            result += 1;
        }
    }
    std.debug.print("{d}\n", .{result});
}
