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

build jaeger-agent ./base/jaeger/jaeger.ext4

build media-frontend ./base/media-frontend/media-frontend.ext4
build nginx-thrift ./base/openresty-thrift/openresty-thrift.ext4

build social-graph-service ./base/social/social-graph.ext4
build compose-post-service ./base/social/compose-post.ext4
build post-storage-service ./base/social/post-storage.ext4
build user-timeline-service ./base/social/user-timeline.ext4
build url-shorten-service ./base/social/url-shorten.ext4
build user-service ./base/social/user.ext4
build media-service ./base/social/media.ext4
build text-service ./base/social/text.ext4
build unique-id-service ./base/social/unique-id.ext4
build user-mention-service ./base/social/user-mention.ext4
build home-timeline-service ./base/social/home-timeline.ext4

build social-graph-redis ./base/redis/redis.ext4
build home-timeline-redis ./base/redis/redis.ext4
build user-timeline-redis ./base/redis/redis.ext4

build post-storage-memcached ./base/memcached/memcached.ext4
build url-shorten-memcached ./base/memcached/memcached.ext4
build user-memcached ./base/memcached/memcached.ext4
build media-memcached ./base/memcached/memcached.ext4

build social-graph-mongodb ./base/mongodb/mongo-4.4.6.ext4
build post-storage-mongodb ./base/mongodb/mongo-4.4.6.ext4
build user-timeline-mongodb ./base/mongodb/mongo-4.4.6.ext4
build url-shorten-mongodb ./base/mongodb/mongo-4.4.6.ext4
build user-mongodb ./base/mongodb/mongo-4.4.6.ext4
build media-mongodb ./base/mongodb/mongo-4.4.6.ext4
