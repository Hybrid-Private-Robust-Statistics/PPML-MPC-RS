#!/bin/bash

PROGRAM="bin/test_arith_bench_trip"
FILE="test_arith_bench_trip"
BASE_DIR="/home/ubuntu/PPML-emp-zk"

PORT=8080

# Define N_D_LIST as an array of "n,d" strings
N_D_LIST=("10000,10" "10000,25" "10000,50" "10000,100")
#N_D_LIST=("10000,10" "100000,10" "1000000,10")
#N_D_LIST=("10,10")
M=2
TIMESTAMP=$(date +"%Y%m%d_%H%M")

for ND in "${N_D_LIST[@]}"; do
    IFS=',' read -r N D <<< "$ND"

    echo ">>> Running $PROGRAM with n=$N and d=$D"

    # Launch all 10 parties in parallel
    for i in 0 5; do

      # Set the -p value based on the party
      if [ "$i" -eq 0 ]; then
          P_VAL=1
      elif [ "$i" -eq 5 ]; then
          P_VAL=0
      fi
      LOG_FILE="logs/party$i-${FILE}-${N}-${D}-${TIMESTAMP}.log"
     #./bin/test_arith_bench_trip 1 8080 10 1 2^C
      if [ "$i" -eq 0 ]; then
        ssh party$i "
          cd $BASE_DIR &&
          mkdir -p logs &&
          nohup ./$PROGRAM  $P_VAL  $PORT $N $D $M > $LOG_FILE 2>&1 &" &
        # Optionally follow logs:
        sleep 1
        ssh party0 "tail -n +1 -f $BASE_DIR/$LOG_FILE" &
      else
        ssh party$i "
          cd $BASE_DIR &&
          mkdir -p logs &&
          nohup ./$PROGRAM  $P_VAL  $PORT $N $D $M > $LOG_FILE 2>&1 &" &
        sleep 1
        ssh party5 "tail -n +1 -f $BASE_DIR/$LOG_FILE" &
      fi
    done
    echo "Waiting for $EXECUTABLE to finish..."
    # Wait for all parties to finish
    while true; do
      sleep 5
      ALL_DONE=true
      for i in 0 5; do
        if ssh party$i pgrep -f bin/test_arith_bench_trip > /dev/null; then
          ALL_DONE=false
          break
        fi
      done
      if $ALL_DONE; then
        break
      fi
    done

    echo " Done: $EXECUTABLE"
    echo
done
