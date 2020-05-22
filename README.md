# zig-bench

A simple benchmarking lib in Zig

```
1/1 test "debug benchmark"...
Benchmark             Iterations   Mean(ns)
-------------------------------------------
sum_slice(block=16)       100000        316
sum_slice(block=32)       100000        287
sum_slice(block=64)       100000        496
sum_slice(block=128)      100000        976
sum_slice(block=256)      100000       1896
sum_slice(block=512)      100000       3750
sum_stream(block=16)      100000       1289
sum_stream(block=32)      100000       2453
sum_stream(block=64)      100000       4797
sum_stream(block=128)      52642       9498
sum_stream(block=256)      26420      18925
sum_stream(block=512)      13322      37533
OK
All 1 tests passed.
1/1 test "release-fast benchmark"...
Benchmark             Iterations   Mean(ns)
-------------------------------------------
sum_slice(block=16)       100000         43
sum_slice(block=32)       100000         46
sum_slice(block=64)       100000         50
sum_slice(block=128)      100000         61
sum_slice(block=256)      100000         80
sum_slice(block=512)      100000         71
sum_stream(block=16)      100000         21
sum_stream(block=32)      100000         22
sum_stream(block=64)      100000         24
sum_stream(block=128)     100000         30
sum_stream(block=256)     100000         43
sum_stream(block=512)     100000         70
OK
All 1 tests passed.
1/1 test "release-safe benchmark"...
Benchmark             Iterations   Mean(ns)
-------------------------------------------
sum_slice(block=16)       100000         63
sum_slice(block=32)       100000         89
sum_slice(block=64)       100000        134
sum_slice(block=128)      100000        136
sum_slice(block=256)      100000        199
sum_slice(block=512)      100000        377
sum_stream(block=16)      100000         84
sum_stream(block=32)      100000        148
sum_stream(block=64)      100000        270
sum_stream(block=128)     100000        519
sum_stream(block=256)     100000       1015
sum_stream(block=512)     100000       2010
OK
All 1 tests passed.
1/1 test "release-small benchmark"...
Benchmark             Iterations   Mean(ns)
-------------------------------------------
sum_slice(block=16)       100000         59
sum_slice(block=32)       100000         89
sum_slice(block=64)       100000        130
sum_slice(block=128)      100000        139
sum_slice(block=256)      100000        198
sum_slice(block=512)      100000        377
sum_stream(block=16)      100000         56
sum_stream(block=32)      100000        103
sum_stream(block=64)      100000        183
sum_stream(block=128)     100000        340
sum_stream(block=256)     100000        657
sum_stream(block=512)     100000       1557
OK
All 1 tests passed.
```
