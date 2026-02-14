#!/bin/bash

COMPILEF="noise_sampling"
BASE_DIR="/home/ubuntu/PPML-MP-SPDZ"

# Define N_D_LIST as an array of "n,d" strings
N_S_LIST=("50,0.052", "50,0.025", "125,0.0436554", "375,0.146", "500,0.516" )
M=3
# Compile for each combination
for NS in "${N_S_LIST[@]}"; do
    IFS=',' read -r N S<<< "$NS"
    echo "Compiling for N=$N, S=$S"

    for i in 0 1 5; do
      ssh party$i "
        cd $BASE_DIR &&
        ./compile.py  $COMPILEF $N $S" &
    done

    wait  # Wait for all SSHs to complete before the next set
done
