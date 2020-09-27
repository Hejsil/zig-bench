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
    const min_iterations: u32 = if (@hasDecl(B, "min_iterations")) B.min_iterations else 10000;
    const max_iterations: u32 = if (@hasDecl(B, "max_iterations")) B.max_iterations else 100000;
    const max_time = 500 * time.millisecond;

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
        var res = [_]u64{ 0, 0, 0 };
        res = try printBenchmark(stream, res, "Benchmark", "", "Iterations", "Mean(ns)");
        inline for (functions) |f| {
            var i: usize = 0;
            while (i < args.len) : (i += 1) {
                res = if (i < arg_names.len)
                    try printBenchmark(stream, res, f.name, arg_names[i], math.maxInt(u32), math.maxInt(u32))
                else
                    try printBenchmark(stream, res, f.name, i, math.maxInt(u32), math.maxInt(u32));
            }
        }
        break :blk res;
    };

    const stderr = std.io.getStdErr().outStream();
    try stderr.writeAll("\n");
    _ = try printBenchmark(stderr, min_width, "Benchmark", "", "Iterations", "Mean(ns)");
    try stderr.writeAll("\n");
    for (min_width) |w|
        try stderr.writeByteNTimes('-', w);
    try stderr.writeByteNTimes('-', min_width.len - 1);
    try stderr.writeAll("\n");

    var timer = try time.Timer.start();
    inline for (functions) |def| {
        inline for (args) |arg, index| {
            var runtime_sum: u128 = 0;

            var i: usize = 0;
            while (i < min_iterations or (i < max_iterations and runtime_sum < max_time)) : (i += 1) {
                timer.reset();

                const res = switch (@TypeOf(arg)) {
                    void => @field(B, def.name)(),
                    else => @field(B, def.name)(arg),
                };
                const runtime = timer.read();
                runtime_sum += runtime;
                doNotOptimize(res);
            }

            const runtime_mean = runtime_sum / i;
            if (index < arg_names.len) {
                _ = try printBenchmark(stderr, min_width, def.name, arg_names[index], i, runtime_mean);
            } else {
                _ = try printBenchmark(stderr, min_width, def.name, index, i, runtime_mean);
            }
            try stderr.writeAll("\n");
        }
    }
}

fn printBenchmark(stream: var, min_widths: [3]u64, func_name: []const u8, arg_name: var, iterations: var, runtime: var) ![3]u64 {
    const arg_len = countingPrint("{}", .{arg_name});
    const name_len = try alignedPrint(stream, .left, min_widths[0], "{}{}{}{}", .{
        func_name,
        "("[0..@boolToInt(arg_len != 0)],
        arg_name,
        ")"[0..@boolToInt(arg_len != 0)],
    });
    try stream.writeAll(" ");
    const it_len = try alignedPrint(stream, .right, min_widths[1], "{}", .{iterations});
    try stream.writeAll(" ");
    const runtime_len = try alignedPrint(stream, .right, min_widths[2], "{}", .{runtime});

    return [_]u64{ name_len, it_len, runtime_len };
}

fn alignedPrint(stream: var, dir: enum { left, right }, width: u64, comptime fmt: []const u8, args: var) !u64 {
    const value_len = countingPrint(fmt, args);

    var cos = io.countingOutStream(stream);
    const cos_stream = cos.outStream();
    if (dir == .right)
        try cos_stream.writeByteNTimes(' ', math.sub(u64, width, value_len) catch 0);
    try cos_stream.print(fmt, args);
    if (dir == .left)
        try cos_stream.writeByteNTimes(' ', math.sub(u64, width, value_len) catch 0);
    return cos.bytes_written;
}

/// Returns the number of bytes that would be written to a stream
/// for a given format string and arguments.
fn countingPrint(comptime fmt: []const u8, args: var) u64 {
    var cos = io.countingOutStream(io.null_out_stream);
    cos.outStream().print(fmt, args) catch unreachable;
    return cos.bytes_written;
}

/// Pretend to use the value so the optimizer cant optimize it out.
fn doNotOptimize(val: var) void {
    const T = @TypeOf(val);
    var store: T = undefined;
    @ptrCast(*volatile T, &store).* = val;
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
        const min_iterations = 1000;
        const max_iterations = 100000;

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

test "benchmark generics" {
    try benchmark(struct {
        pub const args = [_]type{
            @Vector(4, f16),  @Vector(4, f32),  @Vector(4, f64),
            @Vector(8, f16),  @Vector(8, f32),  @Vector(8, f64),
            @Vector(16, f16), @Vector(16, f32), @Vector(16, f64),
        };

        pub const arg_names = [_][]const u8{
            "vec4f16",  "vec4f32",  "vec4f64",
            "vec8f16",  "vec8f32",  "vec8f64",
            "vec16f16", "vec16f32", "vec16f64",
        };

        pub fn sum_vectors(comptime T: type) T {
            const info = @typeInfo(T).Vector;
            const one = @splat(info.len, @as(info.child, 1));
            var vecs: [512]T = [1]T{one} ** 512;
            var res = one;

            for (vecs) |vec| {
                res += vec;
            }
            return res;
        }
    });
}
