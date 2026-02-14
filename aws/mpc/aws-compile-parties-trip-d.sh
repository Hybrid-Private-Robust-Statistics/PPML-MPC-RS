#!/bin/bash

PROGRAM="bench_trip_d"
COMPILEF="bench_trip_d"
BASE_DIR="/home/ubuntu/PPML-MP-SPDZ"

# Define N_D_LIST as an array of "n,d" strings
N_D_LIST=("10000,10" "10000,25" "10000,50", "10000,100")
M=3
# Compile for each combination
for ND in "${N_D_LIST[@]}"; do
    IFS=',' read -r N D <<< "$ND"
    echo "Compiling for M=$M, N=$N, D=$D"

    for i in 0 1 5; do
      ssh party$i "
        cd $BASE_DIR &&
        ./compile.py  $COMPILEF $M $N $D" &
    done

    wait  # Wait for all SSHs to complete before the next set
done
