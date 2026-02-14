# Kill old processes
for i in 0 5; do
    ssh party$i "pkill -f bin/test_arith_bench_trip" || true
done
sleep 2
