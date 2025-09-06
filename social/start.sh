#!/bin/bash

echo "Starting jaeger services..."
./jaeger-agent/boot.sh > /dev/null &

echo "Starting redis services..."
./social-graph-redis/boot.sh > /dev/null &
./home-timeline-redis/boot.sh > /dev/null &
./user-timeline-redis/boot.sh > /dev/null &

echo "Starting mongodb services..."
./social-graph-mongodb/boot.sh > /dev/null &
./post-storage-mongodb/boot.sh > /dev/null &
./user-timeline-mongodb/boot.sh > /dev/null &
./url-shorten-mongodb/boot.sh > /dev/null &
./user-mongodb/boot.sh > /dev/null &
./media-mongodb/boot.sh > /dev/null &

echo "Starting memcached services..."
./post-storage-memcached/boot.sh > /dev/null &
./url-shorten-memcached/boot.sh > /dev/null &
./user-memcached/boot.sh > /dev/null &
./media-memcached/boot.sh > /dev/null &

echo "Sleeping 30s to make sure jaeger, redis and all mongodb and memcached instances are booted up"
sleep 30

echo "Starting social network services..."
./social-graph-service/boot.sh > /dev/null &    # depends on jaeger and social-graph-mongodb
./post-storage-service/boot.sh > /dev/null &    # depends on jaeger and post-storage-mongodb
./user-timeline-service/boot.sh > /dev/null &   # depends on jaeger and user-timeline-mongodb
./url-shorten-service/boot.sh > /dev/null &     # depends on jaeger and url-shorten-mongodb
./user-service/boot.sh > /dev/null &            # depends on jaeger and user-mongodb
./media-service/boot.sh > /dev/null &           # depends on jaeger and media-mongodb

./compose-post-service/boot.sh > /dev/null &    # depends on jaeger
./text-service/boot.sh > /dev/null &            # depends on jaeger
./unique-id-service/boot.sh > /dev/null &       # depends on jaeger
./user-mention-service/boot.sh > /dev/null &    # depends on jaeger
./home-timeline-service/boot.sh > /dev/null &   # depends on jaeger

./media-frontend/boot.sh > /dev/null &          # depends on jaeger
./nginx-thrift/boot.sh > /dev/null &            # depends on jaeger
