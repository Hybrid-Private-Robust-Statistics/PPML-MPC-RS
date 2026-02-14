#!/bin/bash

for i in $(seq 0 9); do
  ssh party$i "cd /home/ubuntu/PPML-MP-SPDZ && make clean "
done
