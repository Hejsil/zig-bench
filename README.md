# zig-bench

A simple benchmarking lib in Zig

```
Test [0/2] test "Debug benchmark"... 
Benchmark             Iterations    Min(ns)    Max(ns)   Variance   Mean(ns)
----------------------------------------------------------------------------
sum_slice(block=16)       100000         90       2690        243        107
sum_slice(block=32)       100000        170       1760        338        190
sum_slice(block=64)       100000        320       2340        476        352
sum_slice(block=128)      100000        630       2290        862        678
sum_slice(block=256)      100000       1270       3170       2402       1336
sum_slice(block=512)      100000       2550       8490       4835       2651
sum_reader(block=16)      100000        990       2640       1592       1039
sum_reader(block=32)      100000       1930       3890       3292       2012
sum_reader(block=64)      100000       3830       6250       6806       3962
sum_reader(block=128)      63673       7660      12830      15703       7852
sum_reader(block=256)      31967      15360      22190      31847      15641
sum_reader(block=512)      16031      30800      34690      59444      31191
Test [1/2] test "Debug benchmark generics"... 
Benchmark             Iterations    Min(ns)    Max(ns)   Variance   Mean(ns)
----------------------------------------------------------------------------
sum_vectors(vec4f16)      100000       2730      13390       3620       2775
sum_vectors(vec4f32)      100000       1289       5800       1277       1296
sum_vectors(vec4f64)      100000       1389       6870       1358       1400
sum_vectors(vec8f16)      100000       4400       9680       4613       4479
sum_vectors(vec8f32)      100000       1389       5180       1231       1400
sum_vectors(vec8f64)      100000       1390       6170       2260       1457
sum_vectors(vec16f16)      61088       8090      13980      15455       8184
sum_vectors(vec16f32)     100000       1399       4560       2069       1441
sum_vectors(vec16f64)     100000       1440       6080       1664       1475
All 2 tests passed.
Test [0/2] test "ReleaseSafe benchmark"... 
Benchmark             Iterations    Min(ns)    Max(ns)   Variance   Mean(ns)
----------------------------------------------------------------------------
sum_slice(block=16)       100000          9       3550        164         18
sum_slice(block=32)       100000          9        940         22         18
sum_slice(block=64)       100000         49       1530         66         52
sum_slice(block=128)      100000         89       1280        102         92
sum_slice(block=256)      100000        169       1690        210        171
sum_slice(block=512)      100000        319       5530        724        329
sum_reader(block=16)      100000         60       2840        180         69
sum_reader(block=32)      100000        110       3059        288        121
sum_reader(block=64)      100000        209       2810        323        224
sum_reader(block=128)     100000        400       1780        387        431
sum_reader(block=256)     100000        790       2220        681        843
sum_reader(block=512)     100000       1550       4300       3805       1669
Test [1/2] test "ReleaseSafe benchmark generics"... 
Benchmark             Iterations    Min(ns)    Max(ns)   Variance   Mean(ns)
----------------------------------------------------------------------------
sum_vectors(vec4f16)      100000       1269       3790       1799       1283
sum_vectors(vec4f32)      100000        319       1680        300        328
sum_vectors(vec4f64)      100000        319       1860        355        329
sum_vectors(vec8f16)      100000       2399       5010       5014       2420
sum_vectors(vec8f32)      100000        319       2660        641        329
sum_vectors(vec8f64)      100000        319       7740       1019        330
sum_vectors(vec16f16)     100000       4599       9970      22580       4636
sum_vectors(vec16f32)     100000        319       4310       1231        330
sum_vectors(vec16f64)     100000        429       4070       1783        439
All 2 tests passed.
Test [0/2] test "ReleaseFast benchmark"... 
Benchmark             Iterations    Min(ns)    Max(ns)   Variance   Mean(ns)
----------------------------------------------------------------------------
sum_slice(block=16)       100000         19       2840        128         21
sum_slice(block=32)       100000         19       1600         78         20
sum_slice(block=64)       100000         19       1970         74         21
sum_slice(block=128)      100000         19       1530         68         21
sum_slice(block=256)      100000         39       1250         74         44
sum_slice(block=512)      100000         59       1150         85         68
sum_reader(block=16)      100000         19       1170         21         20
sum_reader(block=32)      100000         19       1650         74         20
sum_reader(block=64)      100000         19       1250         34         20
sum_reader(block=128)     100000         19       1240         32         20
sum_reader(block=256)     100000         39       2180        177         44
sum_reader(block=512)     100000         59       2470        148         68
Test [1/2] test "ReleaseFast benchmark generics"... 
Benchmark             Iterations    Min(ns)    Max(ns)   Variance   Mean(ns)
----------------------------------------------------------------------------
sum_vectors(vec4f16)      100000       1259       8590       1678       1284
sum_vectors(vec4f32)      100000        319       1440        279        327
sum_vectors(vec4f64)      100000        319       1760        303        327
sum_vectors(vec8f16)      100000       2399       5260       1861       2417
sum_vectors(vec8f32)      100000        319       2080        434        327
sum_vectors(vec8f64)      100000        319       1710        329        328
sum_vectors(vec16f16)     100000       4599       9010       3883       4634
sum_vectors(vec16f32)     100000        319       2800        356        329
sum_vectors(vec16f64)     100000        429       1750        404        436
All 2 tests passed.
Test [0/2] test "ReleaseSmall benchmark"... 
Benchmark             Iterations    Min(ns)    Max(ns)   Variance   Mean(ns)
----------------------------------------------------------------------------
sum_slice(block=16)       100000         19       2760        247         27
sum_slice(block=32)       100000         29       5090        363         37
sum_slice(block=64)       100000         50       2640        177         63
sum_slice(block=128)      100000         90       1830        157        102
sum_slice(block=256)      100000        169       5860        733        201
sum_slice(block=512)      100000        330       3690       1560        365
sum_reader(block=16)      100000        219       1430        276        226
sum_reader(block=32)      100000        420       1870        460        432
sum_reader(block=64)      100000        819       2690        770        837
sum_reader(block=128)     100000       1629       5390       1696       1649
sum_reader(block=256)     100000       3240       9080       3240       3274
sum_reader(block=512)      76638       6469       9780       5302       6524
Test [1/2] test "ReleaseSmall benchmark generics"... 
Benchmark             Iterations    Min(ns)    Max(ns)   Variance   Mean(ns)
----------------------------------------------------------------------------
sum_vectors(vec4f16)      100000       4859      16710       5250       4902
sum_vectors(vec4f32)      100000        319       1650        326        328
sum_vectors(vec4f64)      100000        319       1470        295        327
sum_vectors(vec8f16)      100000       3980       9070       3382       4254
sum_vectors(vec8f32)      100000        319       3740        459        328
sum_vectors(vec8f64)      100000        319       4100        534        330
sum_vectors(vec16f16)      79800       6219      15130      10000       6265
sum_vectors(vec16f32)     100000        319       3340        455        330
sum_vectors(vec16f64)     100000        429       2020        454        438
All 2 tests passed.
```
