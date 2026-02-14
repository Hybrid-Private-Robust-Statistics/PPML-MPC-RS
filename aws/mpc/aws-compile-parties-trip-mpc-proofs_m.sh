#!/bin/bash

PROGRAM="bench_trip_mpc_proofs"
COMPILEF="bench_trip_mpc_proofs"
BASE_DIR="/home/ubuntu/PPML-MP-SPDZ"

# Define N_D_LIST as an array of "n,d" strings
N_D_LIST=("1000,10")
M_LIST=("2" "4" "6" "8" "10")
# Compile for each combination
for ND in "${N_D_LIST[@]}"; do
    IFS=',' read -r N D <<< "$ND"
    for M in "${M_LIST[@]}"; do
        IFS=',' read -r M <<< "$M"
        echo "Compiling for M=$M, N=$N, D=$D"
        if [ "$M" -eq 2 ]; then
            for i in 0 1 5; do
            ssh party$i "
                cd $BASE_DIR &&
                ./compile.py  $COMPILEF $M $N $D" &
            done
        elif [ "$M" -eq 4 ]; then
            for i in 0 1 5 6; do
            ssh party$i "
                cd $BASE_DIR &&
                ./compile.py  $COMPILEF $M $N $D" &
            done
        elif [ "$M" -eq 6 ]; then
            for i in 0 1 2 5 6 7; do
            ssh party$i "
                cd $BASE_DIR &&
                ./compile.py  $COMPILEF $M $N $D" &
            done
        elif [ "$M" -eq 8 ]; then
            for i in 0 1 2 3 5 6 7 8; do
            ssh party$i "
                cd $BASE_DIR &&
                ./compile.py  $COMPILEF $M $N $D" &
            done
        elif [ "$M" -eq 10 ]; then
            for i in $(seq 0 9); do
            ssh party$i "
                cd $BASE_DIR &&
                ./compile.py  $COMPILEF $M $N $D" &
            done
        fi
    done
    wait  # Wait for all SSHs to complete before the next set
done
