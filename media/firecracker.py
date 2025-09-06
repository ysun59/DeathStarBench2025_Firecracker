#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
from string import Template

WORKING_DIR = os.path.dirname(os.path.abspath(__file__))

MEDIA_VMs = [
  { "name": 'jaeger', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m1", "ip": { "host": "10.10.12.2", "guest": "10.10.12.3" }, "mac": "06:aa:c0:a8:02:01" } },
  { "name": 'movie-id-mongodb', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m2", "ip": { "host": "10.10.12.4", "guest": "10.10.12.5" }, "mac": "06:aa:c0:a8:02:02" } },
  { "name": 'user-mongodb', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m3", "ip": { "host": "10.10.12.6", "guest": "10.10.12.7" }, "mac": "06:aa:c0:a8:02:03" } },
  { "name": 'review-storage-mongodb', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m4", "ip": { "host": "10.10.12.8", "guest": "10.10.12.9" }, "mac": "06:aa:c0:a8:02:04" } },
  { "name": 'user-review-mongodb', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m5", "ip": { "host": "10.10.12.10", "guest": "10.10.12.11" }, "mac": "06:aa:c0:a8:02:05" } },
  { "name": 'movie-review-mongodb', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m6", "ip": { "host": "10.10.12.12", "guest": "10.10.12.13" }, "mac": "06:aa:c0:a8:02:06" } },
  { "name": 'cast-info-mongodb', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m7", "ip": { "host": "10.10.12.14", "guest": "10.10.12.15" }, "mac": "06:aa:c0:a8:02:07" } },
  { "name": 'plot-mongodb', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m8", "ip": { "host": "10.10.12.16", "guest": "10.10.12.17" }, "mac": "06:aa:c0:a8:02:08" } },
  { "name": 'movie-info-mongodb', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m9", "ip": { "host": "10.10.12.18", "guest": "10.10.12.19" }, "mac": "06:aa:c0:a8:02:09" } },
  { "name": 'movie-id-memcached', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m10", "ip": { "host": "10.10.12.20", "guest": "10.10.12.21" }, "mac": "06:aa:c0:a8:02:10" } },
  { "name": 'user-memcached', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m11", "ip": { "host": "10.10.12.22", "guest": "10.10.12.23" }, "mac": "06:aa:c0:a8:02:11" } },
  { "name": 'compose-review-memcached', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m12", "ip": { "host": "10.10.12.24", "guest": "10.10.12.25" }, "mac": "06:aa:c0:a8:02:12" } },
  { "name": 'review-storage-memcached', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m13", "ip": { "host": "10.10.12.26", "guest": "10.10.12.27" }, "mac": "06:aa:c0:a8:02:13" } },
  { "name": 'cast-info-memcached', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m14", "ip": { "host": "10.10.12.28", "guest": "10.10.12.29" }, "mac": "06:aa:c0:a8:02:14" } },
  { "name": 'plot-memcached', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m15", "ip": { "host": "10.10.12.30", "guest": "10.10.12.31" }, "mac": "06:aa:c0:a8:02:15" } },
  { "name": 'movie-info-memcached', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m16", "ip": { "host": "10.10.12.32", "guest": "10.10.12.33" }, "mac": "06:aa:c0:a8:02:16" } },
  { "name": 'rating-redis', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m17", "ip": { "host": "10.10.12.34", "guest": "10.10.12.35" }, "mac": "06:aa:c0:a8:02:17" } },
  { "name": 'user-review-redis', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m18", "ip": { "host": "10.10.12.36", "guest": "10.10.12.37" }, "mac": "06:aa:c0:a8:02:18" } },
  { "name": 'movie-review-redis', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m19", "ip": { "host": "10.10.12.38", "guest": "10.10.12.39" }, "mac": "06:aa:c0:a8:02:19" } },
  { "name": 'unique-id-service', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m20", "ip": { "host": "10.10.12.40", "guest": "10.10.12.41" }, "mac": "06:aa:c0:a8:02:20" } },
  { "name": 'movie-id-service', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m21", "ip": { "host": "10.10.12.42", "guest": "10.10.12.43" }, "mac": "06:aa:c0:a8:02:21" } },
  { "name": 'text-service', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m22", "ip": { "host": "10.10.12.44", "guest": "10.10.12.45" }, "mac": "06:aa:c0:a8:02:22" } },
  { "name": 'rating-service', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m23", "ip": { "host": "10.10.12.46", "guest": "10.10.12.47" }, "mac": "06:aa:c0:a8:02:23" } },
  { "name": 'user-service', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m24", "ip": { "host": "10.10.12.48", "guest": "10.10.12.49" }, "mac": "06:aa:c0:a8:02:24" } },
  { "name": 'compose-review-service', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m25", "ip": { "host": "10.10.12.50", "guest": "10.10.12.51" }, "mac": "06:aa:c0:a8:02:25" } },
  { "name": 'review-storage-service', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m26", "ip": { "host": "10.10.12.52", "guest": "10.10.12.53" }, "mac": "06:aa:c0:a8:02:26" } },
  { "name": 'user-review-service', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m27", "ip": { "host": "10.10.12.54", "guest": "10.10.12.55" }, "mac": "06:aa:c0:a8:02:27" } },
  { "name": 'movie-review-service', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m28", "ip": { "host": "10.10.12.56", "guest": "10.10.12.57" }, "mac": "06:aa:c0:a8:02:28" } },
  { "name": 'cast-info-service', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m29", "ip": { "host": "10.10.12.58", "guest": "10.10.12.59" }, "mac": "06:aa:c0:a8:02:29" } },
  { "name": 'plot-service', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m30", "ip": { "host": "10.10.12.60", "guest": "10.10.12.61" }, "mac": "06:aa:c0:a8:02:30" } },
  { "name": 'movie-info-service', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m31", "ip": { "host": "10.10.12.62", "guest": "10.10.12.63" }, "mac": "06:aa:c0:a8:02:31" } },
  { "name": 'nginx-web-server', "cpu": "2", "mem": "1024", "tap": { "name": "tap-m32", "ip": { "host": "10.10.12.64", "guest": "10.10.12.65" }, "mac": "06:aa:c0:a8:02:32" } },
]

FC_CONFIG_TEMPLATE = Template("""\
{
  "boot-source": {
    "kernel_image_path": "$work_dir/vmlinux-6.1.128",
    "boot_args": "console=ttyS0 reboot=k panic=1 pci=off ip=$guest_ip::$host_ip:255.255.255.254:$host_name:eth0:off:8.8.8.8",
    "initrd_path": null
  },
  "drives": [
    {
      "drive_id": "rootfs",
      "path_on_host": "$work_dir/$name/disk.ext4",
      "is_root_device": true,
      "partuuid": null,
      "is_read_only": false,
      "cache_type": "Unsafe",
      "io_engine": "Sync",
      "rate_limiter": null
    }
  ],
  "machine-config": {
    "vcpu_count": $cpu,
    "mem_size_mib": $mem,
    "smt": false,
    "track_dirty_pages": false
  },
  "cpu-config": null,
  "balloon": null,
  "network-interfaces": [
    {
      "iface_id": "eth0",
      "host_dev_name": "$tap_name",
      "guest_mac": "$mac_addr",
      "rx_rate_limiter": null,
      "tx_rate_limiter": null
    }
  ],
  "vsock": null,
  "logger": null,
  "metrics": null,
  "mmds-config": null,
  "entropy": null
}
""")

BOOT_SCRIPT_TEMPLATE = Template("""\
#!/bin/bash

SCRIPT_DIR="$$(cd "$$(dirname "$${BASH_SOURCE[0]}")" && pwd)"

API_SOCKET="/tmp/firecracker-$name.sock"
rm -f $$API_SOCKET

$work_dir/firecracker --api-sock "$$API_SOCKET" --config-file $$SCRIPT_DIR/firecracker.json
""")


def generate_fc_config(vm):
    """Generate Firecracker configuration for a given VM."""
    return FC_CONFIG_TEMPLATE.substitute(
        name=vm['name'],
        cpu=vm['cpu'],
        mem=vm['mem'],
        guest_ip=vm['tap']['ip']['guest'],
        host_ip=vm['tap']['ip']['host'],
        host_name=vm['name'],
        tap_name=vm['tap']['name'],
        mac_addr=vm['tap']['mac'],
        work_dir=WORKING_DIR,
    )

def generate_boot_script(vm):
    """Generate boot script for a given VM."""
    return BOOT_SCRIPT_TEMPLATE.substitute(
      name=vm['name'], 
      work_dir=WORKING_DIR,
    )

def create_tap_devices():
    """Create tap devices for all VMs."""
    for vm in MEDIA_VMs:
        tap_name = vm['tap']['name']
        # Here you would typically use a system command to create the tap device.
        # For example, using `ip tuntap add dev <tap_name> mode tap` in a real scenario.
        print(f"Creating tap device: {tap_name} with IP {vm['tap']['ip']['host']}")
        # This is a placeholder for actual tap device creation logic.
        os.system(f"ip link del {tap_name} 2> /dev/null || true")
        os.system(f"ip tuntap add dev {tap_name} mode tap")
        os.system(f"ip addr add {vm['tap']['ip']['host']}/31 dev {tap_name}")
        os.system(f"ip link set {tap_name} up")

if __name__ == "__main__":
    action = sys.argv[1]

    if action == "prepare-tap-devices":
        create_tap_devices()
        sys.exit(0)

    # read first argument as the vm name
    # read second argument, gen-config or gen-script
    if len(sys.argv) < 3:
        print("Usage: python firecracker.py <vm_name> <gen-config|gen-script|prepare-tap-devices>")
        sys.exit(1)

    vm_name = sys.argv[2]

    # find the VM configuration
    vm_config = next((vm for vm in MEDIA_VMs if vm['name'] == vm_name), None)
    if not vm_config:
        print(f"VM '{vm_name}' not found.")
        sys.exit(1)

    if action == "gen-config":
        config = generate_fc_config(vm_config)
        print(config)
    elif action == "gen-script":  
        script = generate_boot_script(vm_config)
        print(script)
    else:
        print("Invalid action. Use 'gen-config' or 'gen-script'.")
        sys.exit(1)
    sys.exit(0)
