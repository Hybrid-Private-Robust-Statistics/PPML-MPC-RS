#!/bin/bash
for i in $(seq 0 9); do
      ssh party$i "
        source myenv/bin/activate &&
        pip install numpy" &
done


