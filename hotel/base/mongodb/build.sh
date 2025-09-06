#!/bin/bash

set -e

cd "$(dirname "$0")"

rm -f rootfs.tar mongo-5.0.ext4

docker build -t firecracker/mongo:5.0 .
CID=$(docker create firecracker/mongo:5.0)
docker export $CID -o rootfs.tar
docker rm $CID

# rootfs tooks around 1GB
truncate -s 3G mongo-5.0.ext4
mkfs.ext4 mongo-5.0.ext4 

mkdir -p rootfs
sudo mount -o loop mongo-5.0.ext4 rootfs
sudo tar xf rootfs.tar -C rootfs

sudo sh -c 'echo "nameserver 8.8.8.8" > rootfs/etc/resolv.conf'

sudo umount rootfs

rm -rf rootfs rootfs.tar
