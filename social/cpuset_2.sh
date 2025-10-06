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


setCore "user-timeline-redis" "0"
setCore "social-graph-service" "1"
setCore "user-memcached" "2"
setCore "social-graph-redis" "3"
setCore "media-service" "4"
setCore "post-storage-memcached" "5"
setCore "url-shorten-memcached" "6"
setCore "media-memcached" "7"
setCore "social-graph-mongodb" "8"
setCore "user-mongodb" "9"
setCore "media-mongodb" "10"
setCore "media-frontend" "11"
setCore "user-service" "12"
setCore "unique-id-service" "13"
setCore "url-shorten-service" "14"

setCore "user-timeline-service" "15"
setCore "user-mention-service" "16"
setCoreMoreContig "home-timeline-service" "24,25"
setCore "jaeger-agent" "17"
setCore "url-shorten-mongodb" "18"
setCore "post-storage-mongodb" "19"


setCore "home-timeline-redis" "20"
setCore "text-service" "21"


setCoreMoreContig "post-storage-service" "26,27,28,29,30,31"
setCoreMoreContig "nginx-thrift" "32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62"

setCore "user-timeline-mongodb" "22"
setCore "compose-post-service" "23"









