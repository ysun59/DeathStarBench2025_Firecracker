#!/bin/bash

set -e

cd "$(dirname "$0")"

# for service in user unique-id; do
for service in unique-id movie-id text rating user compose-review review-storage user-review movie-review cast-info plot movie-info; do
  echo "Building $service"

  rm -f rootfs-$service.tar $service.ext4

  docker build -t firecracker/media-microservices:$service --target $service .
  CID=$(docker create firecracker/media-microservices:$service)
  docker export $CID -o rootfs-$service.tar
  docker rm $CID

  # each rootfs tooks around 1.07GB
  truncate -s 1800M $service.ext4
  mkfs.ext4 $service.ext4

  mkdir -p rootfs-$service
  sudo mount -o loop $service.ext4 rootfs-$service
  sudo tar xf rootfs-$service.tar -C rootfs-$service

  sudo sh -c "echo 'nameserver 127.0.0.1' > rootfs-$service/etc/resolv.conf"

  sudo umount rootfs-$service

  rm -rf rootfs-$service rootfs-$service.tar
done
