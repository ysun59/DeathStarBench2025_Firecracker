#!/bin/bash

set -e

cd "$(dirname "$0")"

rm -f rootfs.tar consul.ext4

docker build -t firecracker/consul:latest .
CID=$(docker create firecracker/consul:latest)
docker export $CID -o rootfs.tar
docker rm $CID

# rootfs tooks around 261MB
truncate -s 1G consul.ext4
mkfs.ext4 consul.ext4 

mkdir -p rootfs
sudo mount -o loop consul.ext4 rootfs
sudo tar xf rootfs.tar -C rootfs

sudo sh -c 'echo "nameserver 8.8.8.8" > rootfs/etc/resolv.conf'

sudo umount rootfs

rm -rf rootfs rootfs.tar
