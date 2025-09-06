#!/bin/bash

echo "Starting mongodb services..."
./mongodb-attractions/boot.sh > /dev/null &
./mongodb-geo/boot.sh > /dev/null &
./mongodb-profile/boot.sh > /dev/null &
./mongodb-rate/boot.sh > /dev/null &
./mongodb-recommendation/boot.sh > /dev/null &
./mongodb-reservation/boot.sh > /dev/null &
./mongodb-review/boot.sh > /dev/null &
./mongodb-user/boot.sh > /dev/null &

echo "Starting memcached services..."
./memcached-rate/boot.sh > /dev/null &
./memcached-review/boot.sh > /dev/null &
./memcached-profile/boot.sh > /dev/null &
./memcached-reserve/boot.sh > /dev/null &

echo "Starting jaeger and consul services..."
./jaeger/boot.sh > /dev/null &
./consul/boot.sh > /dev/null &

echo "Sleeping 30s to make sure jaeger, consul and all mongodb and memcached instances are booted up"
sleep 30

echo "Starting hotel reservation services..."
./frontend/boot.sh > /dev/null &          # relies on consul
./search/boot.sh > /dev/null &            # relies on consul
./attractions/boot.sh > /dev/null &       # relies on consul, mongodb-attractions
./geo/boot.sh > /dev/null &               # relies on consul, mongodb-geo
./recommendation/boot.sh > /dev/null &    # relies on consul, mongodb-recommendation
./user/boot.sh > /dev/null &              # relies on consul, mongodb-user
./profile/boot.sh > /dev/null &           # relies on consul, mongodb-profile, and memcached-profile
./rate/boot.sh > /dev/null &              # relies on consul, mongodb-rate, and memcached-rate
./reservation/boot.sh > /dev/null &       # relies on consul, mongodb-reservation, and memcached-reserve
./review/boot.sh > /dev/null &            # relies on consul, mongodb-review, and memcached-review
