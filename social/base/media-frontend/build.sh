#!/bin/bash

set -e

cd "$(dirname "$0")"

rm -f rootfs.tar media-frontend.ext4

docker build -t firecracker/media-frontend .
CID=$(docker create firecracker/media-frontend)
docker export $CID -o rootfs.tar
docker rm $CID

# rootfs tooks around 859MB
truncate -s 2G media-frontend.ext4
mkfs.ext4 media-frontend.ext4

mkdir -p rootfs
sudo mount -o loop media-frontend.ext4 rootfs
sudo tar xf rootfs.tar -C rootfs

sudo sh -c 'echo "nameserver 127.0.0.1" > rootfs/etc/resolv.conf'

sudo umount rootfs

rm -rf rootfs rootfs.tar
