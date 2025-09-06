#!/bin/bash

set -e

cd "$(dirname "$0")"

rm -f rootfs.tar openresty-thrift.ext4

docker build -t firecracker/openresty-thrift:media .
CID=$(docker create firecracker/openresty-thrift:media)
docker export $CID -o rootfs.tar
docker rm $CID

# rootfs tooks around 748MB
truncate -s 2G openresty-thrift.ext4
mkfs.ext4 openresty-thrift.ext4

mkdir -p rootfs
sudo mount -o loop openresty-thrift.ext4 rootfs
sudo tar xf rootfs.tar -C rootfs

sudo sh -c 'echo "nameserver 127.0.0.1" > rootfs/etc/resolv.conf'

sudo umount rootfs

rm -rf rootfs rootfs.tar
