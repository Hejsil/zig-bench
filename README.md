# zig-bench

A simple benchmarking lib in Zig

```
Test [0/2] test "Debug benchmark"... 
Benchmark             Iterations    Min(ns)    Max(ns)   Variance   Mean(ns)
----------------------------------------------------------------------------
sum_slice(block=16)       100000         89       3770        443         99
sum_slice(block=32)       100000        159       1830        292        167
sum_slice(block=64)       100000        290       2360        505        311
sum_slice(block=128)      100000        580       2370        689        603
sum_slice(block=256)      100000       1110      13150       2681       1144
sum_slice(block=512)      100000       2219       4460       2515       2267
sum_reader(block=16)      100000        980       2800       2118       1037
sum_reader(block=32)      100000       1920       3780       4084       2000
sum_reader(block=64)      100000       3800       8470      10109       3936
sum_reader(block=128)      64444       7590      13770      12876       7758
sum_reader(block=256)      32211      15240      23060      31526      15522
sum_reader(block=512)      16164      30500      46450      92603      30934
Test [1/2] test "Debug benchmark generics"... 
Benchmark             Iterations    Min(ns)    Max(ns)   Variance   Mean(ns)
----------------------------------------------------------------------------
sum_vectors(vec4f16)      100000       2710       5500       2569       2758
sum_vectors(vec4f32)      100000       1289       2820       1025       1293
sum_vectors(vec4f64)      100000       1389       5480       1233       1400
sum_vectors(vec8f16)      100000       4390       8840      13932       4451
sum_vectors(vec8f32)      100000       1389       7590       2980       1402
sum_vectors(vec8f64)      100000       1389       8920       3598       1439
sum_vectors(vec16f16)      61486       8010      17179     141513       8131
sum_vectors(vec16f32)     100000       1389       7250       6027       1434
sum_vectors(vec16f64)     100000       1429       5280       5398       1459
All 2 tests passed.
Test [0/2] test "ReleaseSafe benchmark"... 
Benchmark             Iterations    Min(ns)    Max(ns)   Variance   Mean(ns)
----------------------------------------------------------------------------
sum_slice(block=16)       100000          9       2610        137         18
sum_slice(block=32)       100000          9       2410        150         18
sum_slice(block=64)       100000         49       2580        263         52
sum_slice(block=128)      100000         89       3600        498         92
sum_slice(block=256)      100000        169       3230        557        171
sum_slice(block=512)      100000        319       5699        605        329
sum_reader(block=16)      100000         60       1380         40         69
sum_reader(block=32)      100000        110       2030        282        122
sum_reader(block=64)      100000        210       2370        528        224
sum_reader(block=128)     100000        399       4900       1047        430
sum_reader(block=256)     100000        780       3440       1842        839
sum_reader(block=512)     100000       1550       7490       5943       1661
Test [1/2] test "ReleaseSafe benchmark generics"... 
Benchmark             Iterations    Min(ns)    Max(ns)   Variance   Mean(ns)
----------------------------------------------------------------------------
sum_vectors(vec4f16)      100000       1260      13420       2659       1284
sum_vectors(vec4f32)      100000        319       1750        317        328
sum_vectors(vec4f64)      100000        319       1760        343        328
sum_vectors(vec8f16)      100000       2399       4680       2268       2418
sum_vectors(vec8f32)      100000        319       2130        335        329
sum_vectors(vec8f64)      100000        319       5750        638        330
sum_vectors(vec16f16)     100000       4590      10789       6280       4628
sum_vectors(vec16f32)     100000        319       4560        498        330
sum_vectors(vec16f64)     100000        429       2700        506        438
All 2 tests passed.
Test [0/2] test "ReleaseFast benchmark"... 
Benchmark             Iterations    Min(ns)    Max(ns)   Variance   Mean(ns)
----------------------------------------------------------------------------
sum_slice(block=16)       100000         19       2370        149         21
sum_slice(block=32)       100000         19      24800       6189         21
sum_slice(block=64)       100000         19       1670         37         21
sum_slice(block=128)      100000         19       1900         76         21
sum_slice(block=256)      100000         39       1440        102         44
sum_slice(block=512)      100000         59       1520        120         68
sum_reader(block=16)      100000         19       2370         83         20
sum_reader(block=32)      100000         19       1520         57         20
sum_reader(block=64)      100000         19       1360         40         20
sum_reader(block=128)     100000         19       1230         36         20
sum_reader(block=256)     100000         39       1380         67         44
sum_reader(block=512)     100000         59       1910        122         68
Test [1/2] test "ReleaseFast benchmark generics"... 
Benchmark             Iterations    Min(ns)    Max(ns)   Variance   Mean(ns)
----------------------------------------------------------------------------
sum_vectors(vec4f16)      100000       1259       3010       1196       1284
sum_vectors(vec4f32)      100000        319       2140        383        327
sum_vectors(vec4f64)      100000        319       1710        334        327
sum_vectors(vec8f16)      100000       2390       4830       1966       2416
sum_vectors(vec8f32)      100000        319       2150        361        327
sum_vectors(vec8f64)      100000        319       1800        304        329
sum_vectors(vec16f16)     100000       4590       8680       4435       4629
sum_vectors(vec16f32)     100000        319       2650        364        330
sum_vectors(vec16f64)     100000        429       1680        415        438
All 2 tests passed.
Test [0/2] test "ReleaseSmall benchmark"... 
Benchmark             Iterations    Min(ns)    Max(ns)   Variance   Mean(ns)
----------------------------------------------------------------------------
sum_slice(block=16)       100000         19       2730        127         28
sum_slice(block=32)       100000         29       1120         66         36
sum_slice(block=64)       100000         50       1370         92         61
sum_slice(block=128)      100000         90       1690        152        100
sum_slice(block=256)      100000        170       4900        565        184
sum_slice(block=512)      100000        329       3280        833        348
sum_reader(block=16)      100000        219       1610        284        227
sum_reader(block=32)      100000        420       2320        612        433
sum_reader(block=64)      100000        829       2570        964        842
sum_reader(block=128)     100000       1639       3300       1501       1661
sum_reader(block=256)     100000       3269       5720       3095       3303
sum_reader(block=512)      75978       6510      13120      27770       6580
Test [1/2] test "ReleaseSmall benchmark generics"... 
Benchmark             Iterations    Min(ns)    Max(ns)   Variance   Mean(ns)
----------------------------------------------------------------------------
sum_vectors(vec4f16)      100000       4869       9660       3985       4900
sum_vectors(vec4f32)      100000        319       1490        315        328
sum_vectors(vec4f64)      100000        319       1650        320        327
sum_vectors(vec8f16)      100000       3900      17220       4962       4257
sum_vectors(vec8f32)      100000        319       1470        304        327
sum_vectors(vec8f64)      100000        319       3450        413        333
sum_vectors(vec16f16)      79863       6209      10050       4641       6260
sum_vectors(vec16f32)     100000        319       2750        410        330
sum_vectors(vec16f64)     100000        429       6819        896        438
All 2 tests passed.
```
