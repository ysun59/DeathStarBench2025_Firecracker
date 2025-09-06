#!/bin/bash

echo "Starting jaeger services..."
./jaeger/boot.sh > /dev/null &

echo "Starting redis services..."
./rating-redis/boot.sh > /dev/null &
./user-review-redis/boot.sh > /dev/null &
./movie-review-redis/boot.sh > /dev/null &

echo "Starting mongodb services..."
./movie-id-mongodb/boot.sh > /dev/null &
./user-mongodb/boot.sh > /dev/null &
./review-storage-mongodb/boot.sh > /dev/null &
./user-review-mongodb/boot.sh > /dev/null &
./movie-review-mongodb/boot.sh > /dev/null &
./cast-info-mongodb/boot.sh > /dev/null &
./plot-mongodb/boot.sh > /dev/null &
./movie-info-mongodb/boot.sh > /dev/null &

echo "Starting memcached services..."
./movie-id-memcached/boot.sh > /dev/null &
./user-memcached/boot.sh > /dev/null &
./compose-review-memcached/boot.sh > /dev/null &
./review-storage-memcached/boot.sh > /dev/null &
./cast-info-memcached/boot.sh > /dev/null &
./plot-memcached/boot.sh > /dev/null &
./movie-info-memcached/boot.sh > /dev/null &

echo "Sleeping 30s to make sure jaeger, redis and all mongodb and memcached instances are booted up"
sleep 30

echo "Starting media micro services..."
./unique-id-service/boot.sh > /dev/null &
./movie-id-service/boot.sh > /dev/null &
./text-service/boot.sh > /dev/null &
./rating-service/boot.sh > /dev/null &
./user-service/boot.sh > /dev/null &
./compose-review-service/boot.sh > /dev/null &
./review-storage-service/boot.sh > /dev/null &
./user-review-service/boot.sh > /dev/null &
./movie-review-service/boot.sh > /dev/null &
./cast-info-service/boot.sh > /dev/null &
./plot-service/boot.sh > /dev/null &
./movie-info-service/boot.sh > /dev/null &

./nginx-web-server/boot.sh > /dev/null &
