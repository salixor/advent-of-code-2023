const std = @import("std");

const numbersAsWords = [_][]const u8{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };

fn getCalibrationValueNoWord(line: []const u8) u8 {
    var firstInt: ?u8 = null;
    var lastInt: ?u8 = null;

    for (line) |c| {
        if (c >= '0' and c <= '9') {
            const digit = c - '0';
            firstInt = if (firstInt == null) digit else firstInt;
            lastInt = digit;
        }
    }

    return 10 * firstInt.? + lastInt.?;
}

fn getCalibrationValue(line: []const u8) u8 {
    var firstInt: ?u8 = null;
    var lastInt: ?u8 = null;

    for (line, 0..) |c, idx| {
        var digit: ?u8 = null;
        if (c >= '0' and c <= '9') {
            digit = c - '0';
        } else {
            for (numbersAsWords, 1..) |asWord, d| {
                if (std.mem.startsWith(u8, line[idx..], asWord)) {
                    digit = @intCast(d);
                }
            }
        }
        firstInt = if (firstInt == null and digit != null) digit else firstInt;
        lastInt = if (digit != null) digit else lastInt;
    }
    return 10 * firstInt.? + lastInt.?;
}

pub fn main() !void {
    const file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    const reader = file.reader();
    const allocator = std.heap.page_allocator;

    var sum1: u32 = 0;
    var sum2: u32 = 0;

    while (try reader.readUntilDelimiterOrEofAlloc(allocator, '\n', 4096)) |line| {
        defer allocator.free(line);
        sum1 += getCalibrationValueNoWord(line);
        sum2 += getCalibrationValue(line);
    }

    std.debug.print("{d} * {d}\n", .{ sum1, sum2 });
}
