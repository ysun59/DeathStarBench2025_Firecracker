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
setCore "social-graph-service" "2"
setCore "user-memcached" "4"
setCore "social-graph-redis" "6"
setCore "media-service" "8"
setCore "post-storage-memcached" "10"
setCore "url-shorten-memcached" "12"
setCore "media-memcached" "14"
setCore "social-graph-mongodb" "16"
setCore "user-mongodb" "18"
setCore "media-mongodb" "20"
setCore "media-frontend" "22"
setCore "user-service" "24"
setCore "unique-id-service" "26"
setCore "url-shorten-service" "28"

setCoreTwo "user-timeline-service" "32,34"
setCoreTwo "user-mention-service" "36,38"
setCoreTwo "home-timeline-service" "40,42"
setCoreTwo "jaeger-agent" "44,46"
setCoreTwo "url-shorten-mongodb" "48,50"
setCoreTwo "post-storage-mongodb" "52,54"


setCoreTwo "home-timeline-redis" "56,58,60,62"
setCoreTwo "text-service" "33,35,37,39"


setCoreTwo "post-storage-service" "41,43"
setCoreTwo "nginx-thrift" "45,47,49,51,53,55,57,59"

setCoreTwo "user-timeline-mongodb" "17,19,21,23,25,27,29,31"
setCoreTwo "compose-post-service" "1,3,5,7,9,11,13,15"









