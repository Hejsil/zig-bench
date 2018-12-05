const builtin = @import("builtin");
const std = @import("std");

const debug = std.debug;
const io = std.io;
const math = std.math;
const mem = std.mem;
const meta = std.meta;
const os = std.os;
const time = os.time;

const Def = builtin.TypeInfo.Definition;

pub fn benchmark(comptime B: type) !void {
    const args = if (getDef(B, "args")) |_| B.args else []void{{}};
    const iterations: u32 = if (getDef(B, "iterations")) |_| B.iterations else 100000;
    const functions = comptime blk: {
        var res: []const Def = []Def{};
        for (meta.definitions(B)) |def| {
            if (def.data != builtin.TypeInfo.Definition.Data.Fn)
                continue;

            res = res ++ []Def{def};
        }

        break :blk res;
    };
    if (functions.len == 0) {
        debug.warn("\nNo benchmarks to run.\n");
    }

    const max_fn_name_len = comptime max(Def, functions, defNameLessThan).?.name.len;
    const max_name_spaces = math.max(max_fn_name_len, "Benchmark".len);
    const max_args_spaces = math.max(args.len, "Arg".len);

    var timer = try time.Timer.start();
    debug.warn("\n");
    debug.warn("Benchmark");
    nTimes(' ', (max_name_spaces - "Benchmark".len) + 1);
    nTimes(' ', max_args_spaces - "Arg".len);
    debug.warn("Arg ");
    nTimes(' ', digits(u64, 10, math.maxInt(u64)) - "Mean(ns)".len);
    debug.warn("Mean(ns)\n");
    nTimes('-', max_name_spaces + max_args_spaces + digits(u64, 10, math.maxInt(u64)) + 2);
    debug.warn("\n");

    inline for (functions) |def| {
        for (args) |arg, index| {
            var runtime_sum: u128 = 0;

            var i: usize = 0;
            while (i < iterations) : (i += 1) {
                timer.reset();

                const res = switch (@typeOf(arg)) {
                    void => @noInlineCall(@field(B, def.name)),
                    else => @noInlineCall(@field(B, def.name), arg),
                };

                const runtime = timer.read();
                runtime_sum += runtime;
                doNotOptimize(res);
            }

            const runtime_mean = @intCast(u64, runtime_sum / iterations);

            debug.warn("{}", def.name);
            nTimes(' ', (max_name_spaces - def.name.len) + 1);
            nTimes(' ', max_args_spaces - digits(usize, 10, index));
            debug.warn("{} ", index);
            nTimes(' ', digits(u64, 10, math.maxInt(u64)) - digits(u64, 10, runtime_mean));
            debug.warn("{}\n", runtime_mean);
        }
    }
}

/// Pretend to use the value so the optimizer cant optimize it out.
fn doNotOptimize(val: var) void {
    const T = @typeOf(val);
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
        debug.warn("{c}", c);
}

fn getDef(comptime T: type, name: []const u8) ?builtin.TypeInfo.Definition {
    for (@typeInfo(T).Struct.defs) |def| {
        if (mem.eql(u8, def.name, name))
            return def;
    }

    return null;
}

fn max(comptime T: type, slice: []const T, lessThan: fn (T, T) bool) ?T {
    const i = maxIndex(T, slice, lessThan) orelse return null;
    return slice[i];
}

fn maxIndex(comptime T: type, slice: []const T, lessThan: fn (T, T) bool) ?usize {
    if (slice.len == 0)
        return null;

    var res: usize = 0;
    for (slice[1..]) |_, i| {
        if (lessThan(slice[res], slice[i + 1]))
            res = i + 1;
    }

    return res;
}

fn defNameLessThan(comptime a: Def, comptime b: Def) bool {
    return mem.lessThan(u8, a.name, b.name);
}

test "benchmark" {
    try benchmark(struct {
        // The functions will be benchmarked with the following inputs.
        // If not present, then it is assumed that the functions
        // take no input.
        var args = [][]const u8{
            []u8{ 1, 10, 100 } ** 16,
            []u8{ 1, 10, 100 } ** 32,
            []u8{ 1, 10, 100 } ** 64,
            []u8{ 1, 10, 100 } ** 128,
            []u8{ 1, 10, 100 } ** 256,
            []u8{ 1, 10, 100 } ** 512,
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
            var stream = &io.SliceInStream.init(slice).stream;
            var res: u64 = 0;
            while (stream.readByte()) |c| {
                res += c;
            } else |_| {}

            return res;
        }
    });
}
