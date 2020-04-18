# zig-bench

A simple benchmarking lib in Zig

```
Test [1/1] test "debug benchmark"...
Benchmark                Mean(ns)
---------------------------------
sum_slice.0                   260
sum_slice.1                   409
sum_slice.2                   759
sum_slice.3                  1339
sum_slice.4                  2576
sum_slice.5                  5042
sum_stream.0                 2273
sum_stream.1                 4542
sum_stream.2                 8926
sum_stream.3                17098
sum_stream.4                33666
sum_stream.5                63961
All 1 tests passed.
Test [1/1] test "release-fast benchmark"...
Benchmark                Mean(ns)
---------------------------------
sum_slice.0                    34
sum_slice.1                    34
sum_slice.2                    34
sum_slice.3                    52
sum_slice.4                    87
sum_slice.5                   160
sum_stream.0                   20
sum_stream.1                   24
sum_stream.2                   31
sum_stream.3                   51
sum_stream.4                   85
sum_stream.5                  154
All 1 tests passed.
Test [1/1] test "release-safe benchmark"...
Benchmark                Mean(ns)
---------------------------------
sum_slice.0                    47
sum_slice.1                    55
sum_slice.2                    79
sum_slice.3                   131
sum_slice.4                   236
sum_slice.5                   446
sum_stream.0                   96
sum_stream.1                  163
sum_stream.2                  296
sum_stream.3                  568
sum_stream.4                 1113
sum_stream.5                 2196
All 1 tests passed.
Test [1/1] test "release-small benchmark"...
Benchmark                Mean(ns)
---------------------------------
sum_slice.0                    57
sum_slice.1                    51
sum_slice.2                    83
sum_slice.3                   148
sum_slice.4                   275
sum_slice.5                   537
sum_stream.0                   68
sum_stream.1                  113
sum_stream.2                  200
sum_stream.3                  378
sum_stream.4                  734
sum_stream.5                 1442
All 1 tests passed.
```
