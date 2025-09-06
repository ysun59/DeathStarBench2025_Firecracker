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

build jaeger ./base/jaeger/jaeger.ext4

build nginx-web-server ./base/openresty-thrift/openresty-thrift.ext4

build unique-id-service ./base/media/unique-id.ext4
build movie-id-service ./base/media/movie-id.ext4
build text-service ./base/media/text.ext4
build rating-service ./base/media/rating.ext4
build user-service ./base/media/user.ext4
build compose-review-service ./base/media/compose-review.ext4
build review-storage-service ./base/media/review-storage.ext4
build user-review-service ./base/media/user-review.ext4
build movie-review-service ./base/media/movie-review.ext4
build cast-info-service ./base/media/cast-info.ext4
build plot-service ./base/media/plot.ext4
build movie-info-service ./base/media/movie-info.ext4

build rating-redis ./base/redis/redis.ext4
build user-review-redis ./base/redis/redis.ext4
build movie-review-redis ./base/redis/redis.ext4

build movie-id-memcached ./base/memcached/memcached.ext4
build user-memcached ./base/memcached/memcached.ext4
build compose-review-memcached ./base/memcached/memcached.ext4
build review-storage-memcached ./base/memcached/memcached.ext4
build cast-info-memcached ./base/memcached/memcached.ext4
build plot-memcached ./base/memcached/memcached.ext4
build movie-info-memcached ./base/memcached/memcached.ext4

build movie-id-mongodb ./base/mongodb/mongo-4.4.6.ext4
build user-mongodb ./base/mongodb/mongo-4.4.6.ext4
build review-storage-mongodb ./base/mongodb/mongo-4.4.6.ext4
build user-review-mongodb ./base/mongodb/mongo-4.4.6.ext4
build movie-review-mongodb ./base/mongodb/mongo-4.4.6.ext4
build cast-info-mongodb ./base/mongodb/mongo-4.4.6.ext4
build plot-mongodb ./base/mongodb/mongo-4.4.6.ext4
build movie-info-mongodb ./base/mongodb/mongo-4.4.6.ext4
