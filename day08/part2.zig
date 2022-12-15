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

    var i: u32 = 0;
    var left: u32 = undefined;
    var top: u32 = undefined;
    var right: u32 = undefined;
    var bottom: u32 = undefined;

    var max_score: u32 = 0;

    while (i < WIDTH * WIDTH) {
        left = 0;
        top = 0;
        right = 0;
        bottom = 0;

        var pos_x: u32 = i % WIDTH;
        var pos_y: u32 = i / WIDTH;

        // i can't believe zig doesn't have [usable] for loops!

        var distance: u32 = 1;
        while (distance < WIDTH - pos_x) {
            right = distance;
            if (data[i + distance] >= data[i]) {
                break;
            }
            distance += 1;
        }

        distance = 1;
        while (distance <= pos_x) {
            left = distance;
            if (data[i - distance] >= data[i]) {
                break;
            }
            distance += 1;
        }

        distance = 1;
        while (distance < WIDTH - pos_y) {
            bottom = distance;
            if (data[i + distance * WIDTH] >= data[i]) {
                break;
            }
            distance += 1;
        }

        distance = 1;
        while (distance <= pos_y) {
            top = distance;

            if (data[i - distance * WIDTH] >= data[i]) {
                break;
            }
            distance += 1;
        }
        var new_score: u32 = left * right * top * bottom;
        if (new_score > max_score) {
            max_score = new_score;
        }
        i += 1;
    }

    std.debug.print("{d}\n", .{max_score});
}
