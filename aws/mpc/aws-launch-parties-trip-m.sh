#!/bin/bash

#PROGRAM="bench_trip_mpc_proofs"
PROGRAM="bench_trip_m"
BASE_DIR="/home/ubuntu/PPML-MP-SPDZ"

# Define N_D_LIST as an array of "n,d" strings
N_D_LIST=("100000,10")
M_LIST=("2" "4" "8" "10")
TIMESTAMP=$(date +"%Y%m%d_%H%M")

for ND in "${N_D_LIST[@]}"; do
    IFS=',' read -r N D <<< "$ND"
    for M in "${M_LIST[@]}"; do
        IFS=',' read -r M <<< "$M"
        EXECUTABLE="${PROGRAM}-${M}-${N}-${D}"
        echo ">>> Running $EXECUTABLE"

        if [ "$M" -eq 2 ]; then
            # Kill old processes
            for i in 0 1; do
            ssh party$i "pkill -f lowgear-party.x" || true
            done
            sleep 2
            # Set the -p value based on the party
            for i in 0 1; do
                if [ "$i" -eq 0 ]; then
                    P_VAL=0
                elif [ "$i" -eq 1 ]; then
                    P_VAL=1
                fi
                LOG_FILE="logs/party$i-${EXECUTABLE}-${TIMESTAMP}.log"

                if [ "$i" -eq 0 ]; then
                    ssh party$i "
                    cd $BASE_DIR &&
                    mkdir -p logs &&
                    nohup ./lowgear-party.x -ip ip_parties2.txt -p $P_VAL  -N $M $EXECUTABLE > $LOG_FILE 2>&1 &" &
                    # Optionally follow logs:
                    sleep 1
                    ssh party0 "tail -n +1 -f $BASE_DIR/$LOG_FILE" &
                else
                    ssh party$i "
                    cd $BASE_DIR &&
                    mkdir -p logs &&
                    nohup ./lowgear-party.x -ip ip_parties2.txt -p $P_VAL -N $M $EXECUTABLE > $LOG_FILE 2>&1 &" &
                fi
            done
            echo "Waiting for $EXECUTABLE to finish..."
            # Wait for all parties to finish
            while true; do
            sleep 5
            ALL_DONE=true
            for i in 0 1; do
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
         elif [ "$M" -eq 4 ]; then
            # Kill old processes
            for i in 0 1 5 6; do
            ssh party$i "pkill -f lowgear-party.x" || true
            done
            sleep 2
            # Set the -p value based on the party
            for i in 0 1 5 6; do
                if [ "$i" -eq 0 ]; then
                    P_VAL=0
                elif [ "$i" -eq 1 ]; then
                    P_VAL=1
                elif [ "$i" -eq 5 ]; then
                    P_VAL=2
                elif [ "$i" -eq 6 ]; then
                    P_VAL=3
                fi

                LOG_FILE="logs/party$i-${EXECUTABLE}-${TIMESTAMP}.log"

                if [ "$i" -eq 0 ]; then
                    ssh party$i "
                    cd $BASE_DIR &&
                    mkdir -p logs &&
                    nohup ./lowgear-party.x -ip ip_parties4.txt -p $P_VAL  -N $M $EXECUTABLE > $LOG_FILE 2>&1 &" &
                    # Optionally follow logs:
                    sleep 1
                    ssh party0 "tail -n +1 -f $BASE_DIR/$LOG_FILE" &
                else
                    ssh party$i "
                    cd $BASE_DIR &&
                    mkdir -p logs &&
                    nohup ./lowgear-party.x -ip ip_parties4.txt -p $P_VAL -N $M $EXECUTABLE > $LOG_FILE 2>&1 &" &
                fi
            done
            echo "Waiting for $EXECUTABLE to finish..."
            # Wait for all parties to finish
            while true; do
            sleep 5
            ALL_DONE=true
            for i in 0 1 5 6; do
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
         elif [ "$M" -eq 6 ]; then
            # Kill old processes
            for i in 0 1 2 5 6 7; do
            ssh party$i "pkill -f lowgear-party.x" || true
            done
            sleep 2
            # Set the -p value based on the party
            for i in 0 1 2 5 6 7; do
                if [ "$i" -eq 0 ]; then
                    P_VAL=0
                elif [ "$i" -eq 1 ]; then
                    P_VAL=1
                elif [ "$i" -eq 2 ]; then
                    P_VAL=2
                elif [ "$i" -eq 5 ]; then
                    P_VAL=3
                elif [ "$i" -eq 6 ]; then
                    P_VAL=4
                elif [ "$i" -eq 7 ]; then
                    P_VAL=5
                fi

                LOG_FILE="logs/party$i-${EXECUTABLE}-${TIMESTAMP}.log"

                if [ "$i" -eq 0 ]; then
                    ssh party$i "
                    cd $BASE_DIR &&
                    mkdir -p logs &&
                    nohup ./lowgear-party.x -ip ip_parties6.txt -p $P_VAL  -N $M $EXECUTABLE > $LOG_FILE 2>&1 &" &
                    # Optionally follow logs:
                    sleep 1
                    ssh party0 "tail -n +1 -f $BASE_DIR/$LOG_FILE" &
                else
                    ssh party$i "
                    cd $BASE_DIR &&
                    mkdir -p logs &&
                    nohup ./lowgear-party.x -ip ip_parties6.txt -p $P_VAL -N $M $EXECUTABLE > $LOG_FILE 2>&1 &" &
                fi
            done
            echo "Waiting for $EXECUTABLE to finish..."
            # Wait for all parties to finish
            while true; do
            sleep 5
            ALL_DONE=true
            for i in 0 1 2 5 6 7; do
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
        elif [ "$M" -eq 8 ]; then
            # Kill old processes
            for i in 0 1 2 3 5 6 7 8; do
            ssh party$i "pkill -f lowgear-party.x" || true
            done
            sleep 2
            # Set the -p value based on the party
            for i in 0 1 2 3 5 6 7 8; do
                if [ "$i" -eq 0 ]; then
                    P_VAL=0
                elif [ "$i" -eq 1 ]; then
                    P_VAL=1
                elif [ "$i" -eq 2 ]; then
                    P_VAL=2
                elif [ "$i" -eq 3 ]; then
                    P_VAL=3
                elif [ "$i" -eq 5 ]; then
                    P_VAL=4
                elif [ "$i" -eq 6 ]; then
                    P_VAL=5
                elif [ "$i" -eq 7 ]; then
                    P_VAL=6
                elif [ "$i" -eq 8 ]; then
                    P_VAL=7
                fi

                LOG_FILE="logs/party$i-${EXECUTABLE}-${TIMESTAMP}.log"

                if [ "$i" -eq 0 ]; then
                    ssh party$i "
                    cd $BASE_DIR &&
                    mkdir -p logs &&
                    nohup ./lowgear-party.x -ip ip_parties8.txt -p $P_VAL  -N $M $EXECUTABLE > $LOG_FILE 2>&1 &" &
                    # Optionally follow logs:
                    sleep 1
                    ssh party0 "tail -n +1 -f $BASE_DIR/$LOG_FILE" &
                else
                    ssh party$i "
                    cd $BASE_DIR &&
                    mkdir -p logs &&
                    nohup ./lowgear-party.x -ip ip_parties8.txt -p $P_VAL -N $M $EXECUTABLE > $LOG_FILE 2>&1 &" &
                fi
            done
            echo "Waiting for $EXECUTABLE to finish..."
            # Wait for all parties to finish
            while true; do
            sleep 5
            ALL_DONE=true
            for i in 0 1 2 3 5 6 7 8; do
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
        elif [ "$M" -eq 10 ]; then
            # Kill old processes
            for i in $(seq 0 9); do
            ssh party$i "pkill -f lowgear-party.x" || true
            done
            sleep 2
            # Set the -p value based on the party
            for i in $(seq 0 9); do
                LOG_FILE="logs/party$i-${EXECUTABLE}-${TIMESTAMP}.log"

                if [ "$i" -eq 0 ]; then
                    ssh party$i "
                    cd $BASE_DIR &&
                    mkdir -p logs &&
                    nohup ./lowgear-party.x -ip ip_parties-all.txt -p $i  -N $M $EXECUTABLE > $LOG_FILE 2>&1 &" &
                    # Optionally follow logs:
                    sleep 1
                    ssh party0 "tail -n +1 -f $BASE_DIR/$LOG_FILE" &
                else
                    ssh party$i "
                    cd $BASE_DIR &&
                    mkdir -p logs &&
                    nohup ./lowgear-party.x -ip ip_parties-all.txt -p $i -N $M $EXECUTABLE > $LOG_FILE 2>&1 &" &
                fi
            done
            echo "Waiting for $EXECUTABLE to finish..."
            # Wait for all parties to finish
            while true; do
            sleep 5
            ALL_DONE=true
            for i in $(seq 0 9); do
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
         fi
    done
done
