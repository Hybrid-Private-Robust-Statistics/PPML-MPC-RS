#!/bin/bash

PROGRAM="noise_sampling"
BASE_DIR="/home/ubuntu/PPML-MP-SPDZ"

# Define N_D_LIST as an array of "n,d" strings
N_S_LIST=("50,0.052", "50,0.025", "125,0.0436554", "375,0.146", "500,0.516" )
M=3
TIMESTAMP=$(date +"%Y%m%d_%H%M")

for ND in "${N_S_LIST[@]}"; do
    IFS=',' read -r N S <<< "$NS"

    EXECUTABLE="${PROGRAM}-${N}-${S}"
    echo ">>> Running $EXECUTABLE"

    # Kill old processes
    for i in 0 1 5; do
      ssh party$i "pkill -f lowgear-party.x" || true
    done
    sleep 2

    # Launch all 10 parties in parallel
    for i in 0 1 5; do

      # Set the -p value based on the party
      if [ "$i" -eq 0 ]; then
          P_VAL=0
      elif [ "$i" -eq 1 ]; then
          P_VAL=1
      elif [ "$i" -eq 5 ]; then
          P_VAL=2
      fi
      LOG_FILE="logs/party$i-${EXECUTABLE}-${TIMESTAMP}.log"

      if [ "$i" -eq 0 ]; then
        ssh party$i "
          cd $BASE_DIR &&
          mkdir -p logs &&
          nohup ./lowgear-party.x -ip ip_parties3.txt -p $P_VAL  -N $M $EXECUTABLE > $LOG_FILE 2>&1 &" &
        # Optionally follow logs:
        sleep 1
        ssh party0 "tail -n +1 -f $BASE_DIR/$LOG_FILE" &
      else
        ssh party$i "
          cd $BASE_DIR &&
          mkdir -p logs &&
          nohup ./lowgear-party.x -ip ip_parties3.txt -p $P_VAL -N $M $EXECUTABLE > $LOG_FILE 2>&1 &" &
      fi
    done

    echo "Waiting for $EXECUTABLE to finish..."
    # Wait for all parties to finish
    while true; do
      sleep 5
      ALL_DONE=true
      for i in 0 1 5; do
        if ssh party$i pgrep -f lowgear-party.x > /dev/null; then
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
