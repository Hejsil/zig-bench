# zig-bench

A simple benchmarking lib in Zig

```
1/1 test "debug benchmark"...
Benchmark                         Mean(ns)
------------------------------------------
sum_slice(block=16)                    195
sum_slice(block=32)                    285
sum_slice(block=64)                    509
sum_slice(block=128)                   977
sum_slice(block=256)                  1915
sum_slice(block=512)                  3731
sum_stream(block=16)                  1286
sum_stream(block=32)                  2496
sum_stream(block=64)                  4852
sum_stream(block=128)                 9595
sum_stream(block=256)                19246
sum_stream(block=512)                38552
OK
All 1 tests passed.
1/1 test "release-fast benchmark"...
Benchmark                         Mean(ns)
------------------------------------------
sum_slice(block=16)                     42
sum_slice(block=32)                     46
sum_slice(block=64)                     56
sum_slice(block=128)                    68
sum_slice(block=256)                    63
sum_slice(block=512)                    71
sum_stream(block=16)                    22
sum_stream(block=32)                    22
sum_stream(block=64)                    24
sum_stream(block=128)                   30
sum_stream(block=256)                   44
sum_stream(block=512)                   70
OK
All 1 tests passed.
1/1 test "release-safe benchmark"...
Benchmark                         Mean(ns)
------------------------------------------
sum_slice(block=16)                     42
sum_slice(block=32)                     91
sum_slice(block=64)                    140
sum_slice(block=128)                   153
sum_slice(block=256)                   209
sum_slice(block=512)                   400
sum_stream(block=16)                    94
sum_stream(block=32)                   165
sum_stream(block=64)                   305
sum_stream(block=128)                  582
sum_stream(block=256)                 1132
sum_stream(block=512)                 2257
OK
All 1 tests passed.
1/1 test "release-small benchmark"...
Benchmark                         Mean(ns)
------------------------------------------
sum_slice(block=16)                     35
sum_slice(block=32)                     48
sum_slice(block=64)                     99
sum_slice(block=128)                   121
sum_slice(block=256)                   202
sum_slice(block=512)                   396
sum_stream(block=16)                    57
sum_stream(block=32)                   126
sum_stream(block=64)                   193
sum_stream(block=128)                  387
sum_stream(block=256)                  672
sum_stream(block=512)                 1326
OK
All 1 tests passed.
```
