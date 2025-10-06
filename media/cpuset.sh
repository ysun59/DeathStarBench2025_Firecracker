#!/bin/bash

set -e


#set firecracker's pid's all the threadID to core, setCore vmName coreNum
#usage example: setCore hotel-reserv-frontend 3
function setCore(){
  PID=`ps aux | grep /tmp/firecracker | grep -v 'grep' | grep $1 | awk {'print $2'}`
	echo "$1 PID is: $PID"

  ps -T -p $PID --ppid $PID

	for loop in $(ps -T -p $PID --ppid $PID | awk {'print $2'} | awk 'NR != 1')
    do echo $loop
       taskset -pc $2 $loop
	done
    echo " "
}

# set to 13, 13, 13, rest->15, 17, 19
function setCoreTwo(){
  PID=`ps aux | grep /tmp/firecracker | grep -v 'grep' | grep $1 | awk {'print $2'}`
	echo "$1 PID is: $PID"

  ps -T -p $PID --ppid $PID

  let firstCore=${2%%,*}
  let lastCore=${2##*,}
  echo "firstCore is: $firstCore"
  echo "lastCore is: $lastCore"

  taskset -pc $firstCore $(ps -T -p $PID --ppid $PID | awk {'print $2'} | awk 'NR==2')
  taskset -pc $firstCore $(ps -T -p $PID --ppid $PID | awk {'print $2'} | awk 'NR==3')
  taskset -pc $firstCore $(ps -T -p $PID --ppid $PID | awk {'print $2'} | awk 'NR==4')

  firstCore=$((firstCore + 2))
  echo "firstCore is: $firstCore"
  
	for loop in $(ps -T -p $PID --ppid $PID | awk {'print $2'} | awk 'NR > 4')
    do echo $loop
       taskset -pc "$firstCore-$lastCore:2" $loop
	done
    echo " "
}

# cpuset to core 35,35,35,rest->36-52
function setCoreMoreContig(){
  PID=`ps aux | grep /tmp/firecracker | grep -v 'grep' | grep $1 | awk {'print $2'}`
	echo "$1 PID is: $PID"

  ps -T -p $PID --ppid $PID

  let firstCore=${2%%,*}
  let lastCore=${2##*,}
  echo "firstCore is: $firstCore"
  echo "lastCore is: $lastCore"

  taskset -pc $firstCore $(ps -T -p $PID --ppid $PID | awk {'print $2'} | awk 'NR==2')
  taskset -pc $firstCore $(ps -T -p $PID --ppid $PID | awk {'print $2'} | awk 'NR==3')
  taskset -pc $firstCore $(ps -T -p $PID --ppid $PID | awk {'print $2'} | awk 'NR==4')

  firstCore=$((firstCore + 1))
  echo "firstCore is: $firstCore"
  
	for loop in $(ps -T -p $PID --ppid $PID | awk {'print $2'} | awk 'NR > 4')
    do echo $loop
       taskset -pc "$firstCore-$lastCore" $loop
	done
    echo " "
}


setCore "movie-id-mongodb" "16"
setCore "user-mongodb" "17"
setCore "review-storage-mongodb" "2"
setCoreMoreContig "user-review-mongodb" "38,39,40,41"
setCoreMoreContig "movie-review-mongodb" "42,43,44,45"
setCore "cast-info-mongodb" "18"
setCore "plot-mongodb" "19"
setCore "movie-info-mongodb" "20"

setCore "movie-id-memcached" "10"
setCore "user-memcached" "11"
setCoreMoreContig "compose-review-memcached" "35,36,37"
setCore "review-storage-memcached" "12"
setCore "cast-info-memcached" "13"
setCore "plot-memcached" "14"
setCore "movie-info-memcached" "15"

setCore "rating-redis" "7"
setCore "user-review-redis" "9"
setCore "movie-review-redis" "8"

setCore "jaeger" "24"
setCoreMoreContig "nginx-web-server" "46,47,48,49"

setCore "unique-id-service" "3"
setCoreMoreContig "movie-id-service" "50,51,52,53"
setCore "text-service" "4"
setCoreMoreContig "rating-service" "26,27,28"
setCore "user-service" "5"
setCoreMoreContig "compose-review-service" "54,55,56,57,58,59,60,61,62"
setCore "review-storage-service" "6"
setCoreMoreContig "user-review-service" "29,30,31"
setCoreMoreContig "movie-review-service" "32,33,34"
setCore "cast-info-service" "21"
setCore "plot-service" "22"
setCore "movie-info-service" "23"
