# Kill old processes
for i in $(seq 0 9); do
    ssh party$i "pkill -f ./compile.py" || true
done
sleep 2
