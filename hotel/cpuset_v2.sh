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


setCore "mongodb-attractions" "34"
setCore "mongodb-geo" "14"
setCore "mongodb-profile" "16"
setCore "mongodb-rate" "18"
setCore "mongodb-recommendation" "20"
setCore "mongodb-reservation" "24"
setCore "mongodb-review" "32"
setCore "mongodb-user" "22"

setCore "memcached-rate" "10"
setCore "memcached-review" "30"
setCore "memcached-profile" "12"
# #5
setCore "memcached-reserve" "9"

setCore "jaeger" "8"
setCore "consul" "0"

# # 7
setCoreTwo "frontend" "13,15"
# # 5
setCore "search" "5"
setCore "firecracker-attractions" "28"
setCore "firecracker-geo" "2"
setCore "firecracker-recommendation" "4"
setCore "firecracker-user" "6"
# 5
setCore "firecracker-profile" "1"
# 9 (6)
setCoreTwo "firecracker-rate" "21,23,25"
# 21(18)
setCoreMoreContig "firecracker-reservation" "35,36,37,38,39,40"
setCore "firecracker-review" "26"
