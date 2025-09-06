#!/bin/bash

set -e

mount_and_brew() {
  local ext4_file="$1"
  local mount_point
  mount_point=$(mktemp -d /tmp/mnt.XXXXXX)
  sudo mount -o loop "$ext4_file" "$mount_point"
  sudo cp hosts "$mount_point"/etc/hosts
  sudo umount "$mount_point"
  rmdir "$mount_point"
}

build() {
  echo "Generating files for $1"
  local vm_name="$1"
  local disk_image="$2"

  mkdir -p "$vm_name"
  cp "$disk_image" "$vm_name/disk.ext4"
  mount_and_brew "$vm_name/disk.ext4"

  ./firecracker.py gen-config "$vm_name" > "$vm_name/firecracker.json"
  ./firecracker.py gen-script "$vm_name" > "$vm_name/boot.sh"
  chmod +x "$vm_name/boot.sh"
}

build consul ./base/consul/consul.ext4
build jaeger ./base/jaeger/jaeger.ext4

build frontend ./base/hotel/frontend.ext4
build profile ./base/hotel/profile.ext4
build search ./base/hotel/search.ext4
build geo ./base/hotel/geo.ext4
build rate ./base/hotel/rate.ext4
build review ./base/hotel/review.ext4
build attractions ./base/hotel/attractions.ext4
build recommendation ./base/hotel/recommendation.ext4
build user ./base/hotel/user.ext4
build reservation ./base/hotel/reservation.ext4

build memcached-rate ./base/memcached/memcached.ext4
build memcached-review ./base/memcached/memcached.ext4
build memcached-profile ./base/memcached/memcached.ext4
build memcached-reserve ./base/memcached/memcached.ext4

build mongodb-geo ./base/mongodb/mongo-5.0.ext4
build mongodb-profile ./base/mongodb/mongo-5.0.ext4
build mongodb-rate ./base/mongodb/mongo-5.0.ext4
build mongodb-review ./base/mongodb/mongo-5.0.ext4
build mongodb-attractions ./base/mongodb/mongo-5.0.ext4
build mongodb-recommendation ./base/mongodb/mongo-5.0.ext4
build mongodb-reservation ./base/mongodb/mongo-5.0.ext4
build mongodb-user ./base/mongodb/mongo-5.0.ext4
