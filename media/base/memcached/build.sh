#!/bin/bash

set -e

cd "$(dirname "$0")"

rm -f rootfs.tar memcached.ext4

docker build -t firecracker/memcached:latest .
CID=$(docker create firecracker/memcached:latest)
docker export $CID -o rootfs.tar
docker rm $CID

# rootfs tooks around 360MB
truncate -s 1G memcached.ext4
mkfs.ext4 memcached.ext4 

mkdir -p rootfs
sudo mount -o loop memcached.ext4 rootfs
sudo tar xf rootfs.tar -C rootfs

sudo sh -c 'echo "nameserver 8.8.8.8" > rootfs/etc/resolv.conf'

sudo umount rootfs

rm -rf rootfs rootfs.tar
