const builtin = @import("builtin");
const std = @import("std");

const debug = std.debug;
const io = std.io;
const math = std.math;
const mem = std.mem;
const meta = std.meta;
const time = std.time;

const Decl = builtin.TypeInfo.Declaration;

pub fn benchmark(comptime B: type) !void {
    const args = if (@hasDecl(B, "args")) B.args else [_]void{{}};
    const arg_names = if (@hasDecl(B, "args") and @hasDecl(B, "arg_names")) B.arg_names else [_]u8{};
    const iterations: u32 = if (@hasDecl(B, "iterations")) B.iterations else 100000;

    const functions = comptime blk: {
        var res: []const Decl = &[_]Decl{};
        for (meta.declarations(B)) |decl| {
            if (decl.data != Decl.Data.Fn)
                continue;
            res = res ++ [_]Decl{decl};
        }

        break :blk res;
    };
    if (functions.len == 0)
        @compileError("No benchmarks to run.");

    const min_width = blk: {
        const stream = io.null_out_stream;
        var res = [_]u64{ 0, 0 };
        res = try printBenchmark(stream, res, "Benchmark", "", "Mean(ns)");
        inline for (functions) |f| {
            for (args) |_, i| {
                res = if (i < arg_names.len)
                    try printBenchmark(stream, res, f.name, arg_names[i], math.maxInt(u64))
                else
                    try printBenchmark(stream, res, f.name, i, math.maxInt(u64));
            }
        }
        break :blk res;
    };

    const stderr = std.io.getStdErr().outStream();
    try stderr.writeAll("\n");
    _ = try printBenchmark(stderr, min_width, "Benchmark", "", "Mean(ns)");
    try stderr.writeAll("\n");
    for (min_width) |w|
        try stderr.writeByteNTimes('-', w);
    try stderr.writeByteNTimes('-', min_width.len - 1);
    try stderr.writeAll("\n");

    var timer = try time.Timer.start();
    inline for (functions) |def| {
        for (args) |arg, index| {
            var runtime_sum: u128 = 0;

            var i: usize = 0;
            while (i < iterations) : (i += 1) {
                timer.reset();

                const res = switch (@TypeOf(arg)) {
                    void => @field(B, def.name)(),
                    else => @field(B, def.name)(arg),
                };
                const runtime = timer.read();
                runtime_sum += runtime;
                doNotOptimize(res);
            }

            const runtime_mean = runtime_sum / iterations;
            if (index < arg_names.len) {
                _ = try printBenchmark(stderr, min_width, def.name, arg_names[index], runtime_mean);
            } else {
                _ = try printBenchmark(stderr, min_width, def.name, index, runtime_mean);
            }
            try stderr.writeAll("\n");
        }
    }
}

fn printBenchmark(stream: var, min_widths: [2]u64, func_name: []const u8, arg_name: var, runtime: var) ![2]u64 {
    const arg_len = countingPrint("{}", .{arg_name});
    const runtime_len_without_pad = countingPrint("{}", .{runtime});

    var cos = io.countingOutStream(stream);
    const cos_stream = cos.outStream();
    try cos_stream.print("{}{}{}{}", .{ func_name, "("[0..@boolToInt(arg_len != 0)], arg_name, ")"[0..@boolToInt(arg_len != 0)] });
    try cos_stream.writeByteNTimes(' ', math.sub(u64, min_widths[0], cos.bytes_written) catch 0);
    const name_len = cos.bytes_written;

    try stream.writeAll(" ");

    cos = io.countingOutStream(stream);
    try cos_stream.writeByteNTimes(' ', math.sub(u64, min_widths[1], runtime_len_without_pad) catch 0);
    try cos_stream.print("{}", .{runtime});
    const runtime_len = cos.bytes_written;

    return [_]u64{ name_len, runtime_len };
}

/// Returns the number of bytes that would be written to a stream
/// for a given format string and arguments.
fn countingPrint(comptime fmt: []const u8, args: var) u64 {
    var cos = io.countingOutStream(io.null_out_stream);
    cos.outStream().print("{}", args) catch unreachable;
    return cos.bytes_written;
}

/// Pretend to use the value so the optimizer cant optimize it out.
fn doNotOptimize(val: var) void {
    const T = @TypeOf(val);
    var store: T = undefined;
    @ptrCast(*volatile T, &store).* = val;
}

fn digits(comptime N: type, comptime base: comptime_int, n: N) usize {
    comptime var res = 1;
    comptime var check = base;

    inline while (check <= math.maxInt(N)) : ({
        check *= base;
        res += 1;
    }) {
        if (n < check)
            return res;
    }

    return res;
}

fn nTimes(c: u8, times: usize) void {
    var i: usize = 0;
    while (i < times) : (i += 1)
        debug.warn("{c}", .{c});
}

test "benchmark" {
    try benchmark(struct {
        // The functions will be benchmarked with the following inputs.
        // If not present, then it is assumed that the functions
        // take no input.
        const args = [_][]const u8{
            &([_]u8{ 1, 10, 100 } ** 16),
            &([_]u8{ 1, 10, 100 } ** 32),
            &([_]u8{ 1, 10, 100 } ** 64),
            &([_]u8{ 1, 10, 100 } ** 128),
            &([_]u8{ 1, 10, 100 } ** 256),
            &([_]u8{ 1, 10, 100 } ** 512),
        };

        // You can specify `arg_names` to give the inputs more meaningful
        // names. If the index of the input exceeds the available string
        // names, the index is used as a backup.
        const arg_names = [_][]const u8{
            "block=16",
            "block=32",
            "block=64",
            "block=128",
            "block=256",
            "block=512",
        };

        // How many iterations to run each benchmark.
        // If not present then a default will be used.
        const iterations = 100000;

        fn sum_slice(slice: []const u8) u64 {
            var res: u64 = 0;
            for (slice) |item|
                res += item;

            return res;
        }

        fn sum_stream(slice: []const u8) u64 {
            var stream = &io.fixedBufferStream(slice).inStream();
            var res: u64 = 0;
            while (stream.readByte()) |c| {
                res += c;
            } else |_| {}

            return res;
        }
    });
}
