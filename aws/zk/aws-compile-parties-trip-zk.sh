

BINPROGRAM="bin/test_arith_bench_trip"
COMPILEF="test/arith/bench_trip.cpp"
BASE_DIR="/home/ubuntu/PPML-emp-zk"


for i in 0 5; do
  ssh party$i "
    echo "Compiling $COMPILEF"
    cd $BASE_DIR &&
    g++ -g -std=c++17 -march=native -o $BINPROGRAM  $COMPILEF  -I/usr/local/include -L/usr/local/lib  -lemp-tool  -lemp-zk -lssl -lcrypto -lgmp" &
done

