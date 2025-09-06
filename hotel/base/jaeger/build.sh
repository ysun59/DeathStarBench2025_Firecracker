#!/bin/bash

set -e

cd "$(dirname "$0")"

rm -f rootfs.tar jaeger.ext4

docker build -t firecracker/jaeger:latest .
CID=$(docker create firecracker/jaeger:latest)
docker export $CID -o rootfs.tar
docker rm $CID

# rootfs tooks around 133MB
truncate -s 1G jaeger.ext4
mkfs.ext4 jaeger.ext4 

mkdir -p rootfs
sudo mount -o loop jaeger.ext4 rootfs
sudo tar xf rootfs.tar -C rootfs

sudo sh -c 'echo "nameserver 8.8.8.8" > rootfs/etc/resolv.conf'

sudo umount rootfs

rm -rf rootfs rootfs.tar
