#!/bin/bash

set -e

cd "$(dirname "$0")"

# for service in frontend; do
for service in attractions frontend geo profile rate recommendation reservation review search user; do
  echo "Building $service"

  rm -f rootfs-$service.tar $service.ext4

  docker build -t firecracker/hotel-reservation:$service --target $service .
  CID=$(docker create firecracker/hotel-reservation:$service)
  docker export $CID -o rootfs-$service.tar
  docker rm $CID

  # each rootfs tooks around 1.18GB
  truncate -s 2G $service.ext4
  mkfs.ext4 $service.ext4

  mkdir -p rootfs-$service
  sudo mount -o loop $service.ext4 rootfs-$service
  sudo tar xf rootfs-$service.tar -C rootfs-$service

  sudo sh -c "echo 'nameserver 8.8.8.8' > rootfs-$service/etc/resolv.conf"

  sudo umount rootfs-$service

  rm -rf rootfs-$service rootfs-$service.tar
done
