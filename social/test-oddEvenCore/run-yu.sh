#!/bin/bash
# run-yu.sh

set -eu  # 缺参或出错立即退出（-u: 未设置变量报错）
: "${2:?usage: $0 <arg1> <arg2>}"  # 没有 $2 就报错并退出

echo "thread: 20, connection: 60, R: $1, wrk choose: $2"
DEST="firecracker_t_20_c_60_composePosts_R_$1"
DEST2="firecracker_t_20_c_60_readHomeTimeline_R_$1"
DEST3="firecracker_t_20_c_60_readUserTimeline_R_$1"
mkdir -p /home/yu/Res/$DEST
mkdir -p /home/yu/Res/$DEST2
mkdir -p /home/yu/Res/$DEST3

echo "===================================="

cd ..

cp "firecracker_$2.py" "firecracker.py"
cp "cpuset_$2.sh" "cpuset.sh"

make build
sudo make run

# verify firecrackers
# ps aux | grep firecracker.json

echo "===================================="
# let 24 firecrackers, each set to different cores, from core 0-32, 34-52
sudo make cpuset

sleep 5
echo "===================================="
cd /home/yu/DeathStarBench2025/socialNetwork
python3 scripts/init_social_graph.py --ip=10.10.11.51 --graph=socfb-Reed98

echo "===================================="
# Compose posts
cd /home/yu/DeathStarBench2025/socialNetwork
sleep 50

if [[ $2 -eq 1 ]];then
    echo "wrk choose 1"
    echo "wrk's current affinity list: 61, 63"
    taskset -c 61,63 ../wrk2/wrk -D exp -t 20 -c 60 -d 60 --timeout 5 -L -s ./wrk2/scripts/social-network/compose-post.lua http://10.10.11.51:8080/wrk2-api/post/compose -R $1 > "/home/yu/Res/${DEST}/wrk.txt" &
elif [[ $2 -eq 2 && $1 -ge 1200 ]]; then
    echo "wrk choose 2 and >= 1200"
    echo "wrk's current affinity list: 63, wrk is 1200"
    taskset -c 63 ../wrk2/wrk -D exp -t 20 -c 60 -d 60 --timeout 5 -L -s ./wrk2/scripts/social-network/compose-post.lua http://10.10.11.51:8080/wrk2-api/post/compose -R 1200 > "/home/yu/Res/${DEST}/wrk.txt" &
elif [[ $2 -eq 2 ]];then
    echo "wrk choose 2"
    echo "wrk's current affinity list: 63"
    taskset -c 63 ../wrk2/wrk -D exp -t 20 -c 60 -d 60 --timeout 5 -L -s ./wrk2/scripts/social-network/compose-post.lua http://10.10.11.51:8080/wrk2-api/post/compose -R $1 > "/home/yu/Res/${DEST}/wrk.txt" &
elif [[ $2 -eq 3 ]];then
    echo "wrk choose 3"
    echo "wrk's current affinity list: 63"
    taskset -c 61,63 ../wrk2/wrk -D exp -t 20 -c 60 -d 60 --timeout 5 -L -s ./wrk2/scripts/social-network/compose-post.lua http://10.10.11.51:8080/wrk2-api/post/compose -R $1 > "/home/yu/Res/${DEST}/wrk.txt" &
else
    echo "mistake wrk input $2, only support 1, 2, 3"
fi

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
cat "/home/yu/Res/${DEST}/wrk.txt"



echo "===================================="
# Read home timelines
sleep 50


if [[ $2 -eq 1 ]];then
    echo "wrk choose 1"
    echo "wrk's current affinity list: 61, 63"
    taskset -c 61,63 ../wrk2/wrk -D exp -t 20 -c 60 -d 60 --timeout 5 -L -s ./wrk2/scripts/social-network/read-home-timeline.lua http://10.10.11.51:8080/wrk2-api/home-timeline/read -R $1 > "/home/yu/Res/${DEST2}/wrk.txt" &
elif [[ $2 -eq 2 ]];then
    echo "wrk choose 2"
    echo "wrk's current affinity list: 63"
    taskset -c 63 ../wrk2/wrk -D exp -t 20 -c 60 -d 60 --timeout 5 -L -s ./wrk2/scripts/social-network/read-home-timeline.lua http://10.10.11.51:8080/wrk2-api/home-timeline/read -R $1 > "/home/yu/Res/${DEST2}/wrk.txt" &
elif [[ $2 -eq 3 ]];then
    echo "wrk choose 3"
    echo "wrk's current affinity list: 63"
    taskset -c 61,63 ../wrk2/wrk -D exp -t 20 -c 60 -d 60 --timeout 5 -L -s ./wrk2/scripts/social-network/read-home-timeline.lua http://10.10.11.51:8080/wrk2-api/home-timeline/read -R $1 > "/home/yu/Res/${DEST2}/wrk.txt" &
else
    echo "mistake wrk input $2, only support 1, 2, 3"
fi


WRK=$!
#sleep 1.  #warmup
mpstat -P ALL 1 > "/home/yu/Res/${DEST2}/cpu_perf.txt" &
iostat -x -k 1 > "/home/yu/Res/${DEST2}/perf.txt" &
# ./test-oddEvenCore/runPerf.sh $DEST2 &
./test-oddEvenCore/runSchedstat.sh $DEST2 &
./test-oddEvenCore/runSchedDebug.sh $DEST2 &
./test-oddEvenCore/runInterrupts.sh $DEST2 &
wait $WRK
killall iostat mpstat
cat "/home/yu/Res/${DEST2}/wrk.txt"

echo "===================================="
# Read user timelines
sleep 50


if [[ $2 -eq 1 ]];then
    echo "wrk choose 1"
    echo "wrk's current affinity list: 61, 63"
    taskset -c 61,63 ../wrk2/wrk -D exp -t 20 -c 60 -d 60 --timeout 5 -L -s ./wrk2/scripts/social-network/read-user-timeline.lua http://10.10.11.51:8080/wrk2-api/user-timeline/read -R $1 > "/home/yu/Res/${DEST3}/wrk.txt" &
elif [[ $2 -eq 2 ]];then
    echo "wrk choose 2"
    echo "wrk's current affinity list: 63"
    taskset -c 63 ../wrk2/wrk -D exp -t 20 -c 60 -d 60 --timeout 5 -L -s ./wrk2/scripts/social-network/read-user-timeline.lua http://10.10.11.51:8080/wrk2-api/user-timeline/read -R $1 > "/home/yu/Res/${DEST3}/wrk.txt" &
elif [[ $2 -eq 3 ]];then
    echo "wrk choose 3"
    echo "wrk's current affinity list: 63"
    taskset -c 61,63 ../wrk2/wrk -D exp -t 20 -c 60 -d 60 --timeout 5 -L -s ./wrk2/scripts/social-network/read-user-timeline.lua http://10.10.11.51:8080/wrk2-api/user-timeline/read -R $1 > "/home/yu/Res/${DEST3}/wrk.txt" &
else
    echo "mistake wrk input $2, only support 1, 2, 3"
fi

WRK=$!
#sleep 1.  #warmup
mpstat -P ALL 1 > "/home/yu/Res/${DEST3}/cpu_perf.txt" &
iostat -x -k 1 > "/home/yu/Res/${DEST3}/perf.txt" &
# ./test-oddEvenCore/runPerf.sh $DEST3 &
./test-oddEvenCore/runSchedstat.sh $DEST3 &
./test-oddEvenCore/runSchedDebug.sh $DEST3 &
./test-oddEvenCore/runInterrupts.sh $DEST3 &
wait $WRK
killall iostat mpstat
cat "/home/yu/Res/${DEST3}/wrk.txt"






cd /home/yu/DeathStarBench2025_Firecracker/social
sudo make stop
make clean

sudo sh -c 'sync; echo 3 > /proc/sys/vm/drop_caches'
# verify remove the cache
# grep -E '^(Cached|Buffers):' /proc/meminfo