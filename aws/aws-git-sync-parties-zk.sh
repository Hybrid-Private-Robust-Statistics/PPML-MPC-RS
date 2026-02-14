#!/bin/bash


for i in 0 5; do
  ssh party$i "cd /home/ubuntu/PPML-emp-zk && git pull " &
done
