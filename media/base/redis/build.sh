#!/bin/bash

set -e

cd "$(dirname "$0")"

rm -f rootfs.tar redis.ext4

docker build -t firecracker/redis:latest .
CID=$(docker create firecracker/redis:latest)
docker export $CID -o rootfs.tar
docker rm $CID

# rootfs tooks around 423MB
truncate -s 2G redis.ext4
mkfs.ext4 redis.ext4

mkdir -p rootfs
sudo mount -o loop redis.ext4 rootfs
sudo tar xf rootfs.tar -C rootfs

sudo sh -c 'echo "nameserver 8.8.8.8" > rootfs/etc/resolv.conf'
sudo sh -c 'rm -f rootfs/.dockerenv'

sudo umount rootfs

rm -rf rootfs rootfs.tar
