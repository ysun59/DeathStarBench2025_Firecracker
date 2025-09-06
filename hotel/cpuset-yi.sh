#!/bin/bash

# Function: evenly cpuset to TID, for example: set all threads of one firecracker to core 2, 4, 6
set -e

set_cpu_for_service() {
  local service_name=$1
  local cpulist=$2

  PIDs=`ps aux | grep /tmp/firecracker | grep -v 'grep' | grep $1 | awk {'print $2'}`
  for pid in $PIDs; do
    taskset -a -p --cpu-list $cpulist $pid
  done
}

set_cpu_for_service "mongodb-attractions" "34"
set_cpu_for_service "mongodb-geo" "14"
set_cpu_for_service "mongodb-profile" "16"
set_cpu_for_service "mongodb-rate" "18"
set_cpu_for_service "mongodb-recommendation" "20"
set_cpu_for_service "mongodb-reservation" "24"
set_cpu_for_service "mongodb-review" "32"
set_cpu_for_service "mongodb-user" "22"

set_cpu_for_service "memcached-rate" "10"
set_cpu_for_service "memcached-review" "30"
set_cpu_for_service "memcached-profile" "12"
set_cpu_for_service "memcached-reserve" "9,11"

set_cpu_for_service "jaeger" "8"
set_cpu_for_service "consul" "0"

set_cpu_for_service "frontend" "13,15,17,19"
set_cpu_for_service "search" "5,7"
set_cpu_for_service "firecracker-attractions" "28"
set_cpu_for_service "firecracker-geo" "2"
set_cpu_for_service "firecracker-recommendation" "4"
set_cpu_for_service "firecracker-user" "6"
set_cpu_for_service "firecracker-profile" "1,3"
set_cpu_for_service "firecracker-rate" "21,23,25,27,29,31"
set_cpu_for_service "firecracker-reservation" "35-52"
set_cpu_for_service "firecracker-review" "26"
