#!/bin/bash
# run-fire.sh

./run-yu.sh 100
sleep 60
./run-yu.sh 200
sleep 60
./run-yu.sh 400
sleep 60
./run-yu.sh 500
sleep 60


./run-yu.sh 600
sleep 60
./run-yu.sh 800
sleep 60
./run-yu.sh 1000
sleep 60
./run-yu.sh 1200
sleep 60


cp README_YU.md /home/yu/Res/README_YU.md
# mv /home/yu/Res /home/yu/Res-firecracker-random-latency-v1
# mv /home/yu/Res /home/yu/Res-firecracker-random-perf-v1
