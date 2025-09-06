#!/bin/bash

set -e

set_cpu_for_service() {
  local service_name=$1
  local cpulist=$2

  PIDs=`ps aux | grep /tmp/firecracker-$1.sock | grep -v 'grep' | awk {'print $2'}`
  for pid in $PIDs; do
    taskset -a -p --cpu-list $cpulist $pid
  done
}

set_cpu_for_service "movie-id-mongodb" "0-3"
set_cpu_for_service "user-mongodb" "0-3"
set_cpu_for_service "review-storage-mongodb" "0-3"
set_cpu_for_service "user-review-mongodb" "0-3"
set_cpu_for_service "movie-review-mongodb" "0-3"
set_cpu_for_service "cast-info-mongodb" "0-3"
set_cpu_for_service "plot-mongodb" "0-3"
set_cpu_for_service "movie-info-mongodb" "0-3"

set_cpu_for_service "movie-id-memcached" "4-5"
set_cpu_for_service "user-memcached" "4-5"
set_cpu_for_service "compose-review-memcached" "4-5"
set_cpu_for_service "review-storage-memcached" "4-5"
set_cpu_for_service "cast-info-memcached" "4-5"
set_cpu_for_service "plot-memcached" "4-5"
set_cpu_for_service "movie-info-memcached" "4-5"

set_cpu_for_service "rating-redis" "4-5"
set_cpu_for_service "user-review-redis" "4-5"
set_cpu_for_service "movie-review-redis" "4-5"

set_cpu_for_service "jaeger" "6"
set_cpu_for_service "nginx-web-server" "7"

set_cpu_for_service "unique-id-service" "8-9"
set_cpu_for_service "movie-id-service" "8-9"
set_cpu_for_service "text-service" "8-9"
set_cpu_for_service "rating-service" "8-9"
set_cpu_for_service "user-service" "8-9"
set_cpu_for_service "compose-review-service" "8-9"
set_cpu_for_service "review-storage-service" "8-9"
set_cpu_for_service "user-review-service" "8-9"
set_cpu_for_service "movie-review-service" "8-9"
set_cpu_for_service "cast-info-service" "8-9"
set_cpu_for_service "plot-service" "8-9"
set_cpu_for_service "movie-info-service" "8-9"
