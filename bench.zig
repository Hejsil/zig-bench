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

    comptime var max_fn_name_len: usize = 0;
    const functions = comptime blk: {
        var res: []const Decl = &[_]Decl{};
        for (meta.declarations(B)) |decl| {
            if (decl.data != Decl.Data.Fn)
                continue;

            if (max_fn_name_len < decl.name.len)
                max_fn_name_len = decl.name.len;
            res = res ++ [_]Decl{decl};
        }

        break :blk res;
    };
    if (functions.len == 0)
        @compileError("No benchmarks to run.");

    const has_arg_names = arg_names.len > 0;
    var max_name_spaces: usize = undefined;
    if (has_arg_names) {
        comptime var longest: usize = 0;
        inline for (args) |_, index| {
            if (index < arg_names.len and arg_names[index].len > longest) {
                longest = arg_names[index].len;
            }
        }
        max_name_spaces = comptime math.max(max_fn_name_len + longest + 1, "Benchmark".len);
    } else {
        max_name_spaces = comptime math.max(max_fn_name_len + digits(u64, 10, args.len) + 1, "Benchmark".len);
    }

    var timer = try time.Timer.start();
    debug.warn("\n", .{});
    debug.warn("Benchmark", .{});
    nTimes(' ', (max_name_spaces - "Benchmark".len) + 1);
    nTimes(' ', digits(u64, 10, math.maxInt(u64)) - "Mean(ns)".len);
    debug.warn("Mean(ns)\n", .{});
    nTimes('-', max_name_spaces + digits(u64, 10, math.maxInt(u64)) + 1);
    debug.warn("\n", .{});

    inline for (functions) |def| {
        for (args) |arg, index| {
            var runtime_sum: u128 = 0;

            var i: usize = 0;
            while (i < iterations) : (i += 1) {
                timer.reset();

                const res = switch (@TypeOf(arg)) {
                    void => @call(.{ .modifier = .never_inline }, @field(B, def.name), .{}),
                    else => @field(B, def.name)(arg),

                    // Compiler is being a bitch. Idk why it gives this error:
                    // error: assign to constant
                    //else => @call(.{ .modifier = .never_inline }, @field(B, def.name), .{arg}),
                };
                const runtime = timer.read();
                runtime_sum += runtime;
                doNotOptimize(res);
            }

            var run_name_length: usize = undefined;

            if (has_arg_names and index < arg_names.len) {
                const input_name = arg_names[index];
                debug.warn("{}.{}", .{ def.name, input_name });
                // {func}.{input}
                run_name_length = 1 + def.name.len + input_name.len;
            } else {
                debug.warn("{}.{}", .{ def.name, index });
                run_name_length = 1 + def.name.len + digits(u64, 10, index);
            }

            const runtime_mean = @intCast(u64, runtime_sum / iterations);
            nTimes(' ', (max_name_spaces - run_name_length) + 1);
            nTimes(' ', digits(u64, 10, math.maxInt(u64)) - digits(u64, 10, runtime_mean));
            debug.warn("{}\n", .{runtime_mean});
        }
    }
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
