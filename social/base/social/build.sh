#!/bin/bash

set -e

cd "$(dirname "$0")"

# for service in compose-post; do
for service in compose-post home-timeline media post-storage social-graph text unique-id url-shorten user-mention user-timeline user; do
  echo "Building $service"

  rm -f rootfs-$service.tar $service.ext4

  docker build -t firecracker/social-network:$service --target $service .
  CID=$(docker create firecracker/social-network:$service)
  docker export $CID -o rootfs-$service.tar
  docker rm $CID

  # each rootfs tooks around 484MB
  truncate -s 1G $service.ext4
  mkfs.ext4 $service.ext4

  mkdir -p rootfs-$service
  sudo mount -o loop $service.ext4 rootfs-$service
  sudo tar xf rootfs-$service.tar -C rootfs-$service

  sudo sh -c "echo 'nameserver 127.0.0.1' > rootfs-$service/etc/resolv.conf"

  sudo umount rootfs-$service

  rm -rf rootfs-$service rootfs-$service.tar
done
