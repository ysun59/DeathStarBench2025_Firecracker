#!/bin/bash

set -e

PIDs=`ps aux | grep /tmp/firecracker | grep -v 'grep' | awk {'print $2'}`

for pid in $PIDs; do
  # extract pid name
  service_name=$(ps $pid | awk -F'firecracker-|\\.sock' '{print $2}' | tr -d '\n')

  echo "Stopping service $service_name with PID $pid"
  kill $pid

  rm -f /tmp/firecracker-$service_name.sock
done
