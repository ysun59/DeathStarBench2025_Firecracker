#!/bin/bash
# run-yu.sh

echo "thread: 20, connection: 60, R: $1"
DEST="firecracker_t_20_c_60_R_$1"
mkdir -p /home/yu/Res/$DEST

echo "===================================="

cd ..
make build
sudo make run

# verify firecrackers
# ps aux | grep firecracker.json

echo "===================================="
# let 24 firecrackers, each set to different cores, from core 0-32, 34-52
sudo make cpuset

echo "===================================="
cd /home/yu/DeathStarBench2025/hotelReservation
sleep 20

echo "wrk's current affinity list: 63"
taskset -c 63 ../wrk2/wrk -D exp -t 20 -c 60 -d 60 --timeout 5 -L -s ./wrk2/scripts/hotel-reservation/mixed-workload_type_1.lua http://10.10.10.5:5000 -R $1 > "/home/yu/Res/${DEST}/wrk.txt" &

WRK=$!
#sleep 1.  #warmup
mpstat -P ALL 1 > "/home/yu/Res/${DEST}/cpu_perf.txt" &
iostat -x -k 1 > "/home/yu/Res/${DEST}/perf.txt" &
# ./test-oddEvenCore/runPerf.sh $DEST &
./test-oddEvenCore/runSchedstat.sh $DEST &
./test-oddEvenCore/runSchedDebug.sh $DEST &
./test-oddEvenCore/runInterrupts.sh $DEST &
wait $WRK
killall iostat mpstat




cd /home/yu/hotel
sudo make stop
make clean

cat "/home/yu/Res/${DEST}/wrk.txt"


sudo sh -c 'sync; echo 3 > /proc/sys/vm/drop_caches'
# verify remove the cache
# grep -E '^(Cached|Buffers):' /proc/meminfo