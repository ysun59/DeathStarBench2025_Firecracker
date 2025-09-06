#!/bin/bash

set -e

cd "$(dirname "$0")"

rm -f rootfs.tar mongo-4.4.6.ext4

docker build -t firecracker/mongo:4.4.6 .
CID=$(docker create firecracker/mongo:4.4.6)
docker export $CID -o rootfs.tar
docker rm $CID

# rootfs tooks around 656MB
truncate -s 3G mongo-4.4.6.ext4
mkfs.ext4 mongo-4.4.6.ext4

mkdir -p rootfs
sudo mount -o loop mongo-4.4.6.ext4 rootfs
sudo tar xf rootfs.tar -C rootfs

sudo sh -c 'echo "nameserver 8.8.8.8" > rootfs/etc/resolv.conf'

sudo umount rootfs

rm -rf rootfs rootfs.tar
