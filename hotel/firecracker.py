#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
from string import Template

WORKING_DIR = os.path.dirname(os.path.abspath(__file__))

HOTEL_VMs = [
  { "name": 'consul', "cpu": "1", "mem": "1024", "tap": { "name": "tap-h0", "ip": { "host": "10.10.10.2", "guest": "10.10.10.3" }, "mac": "06:aa:c0:a8:00:01" } },
  { "name": 'frontend', "cpu": "4", "mem": "1024", "tap": { "name": "tap-h1", "ip": { "host": "10.10.10.4", "guest": "10.10.10.5" }, "mac": "06:aa:c0:a8:00:02" } },
  { "name": 'profile', "cpu": "2", "mem": "1024", "tap": { "name": "tap-h2", "ip": { "host": "10.10.10.6", "guest": "10.10.10.7" }, "mac": "06:aa:c0:a8:00:03" } },
  { "name": 'search', "cpu": "2", "mem": "1024", "tap": { "name": "tap-h3", "ip": { "host": "10.10.10.8", "guest": "10.10.10.9" }, "mac": "06:aa:c0:a8:00:04" } },
  { "name": 'geo', "cpu": "1", "mem": "1024", "tap": { "name": "tap-h4", "ip": { "host": "10.10.10.10", "guest": "10.10.10.11" }, "mac": "06:aa:c0:a8:00:05" } },
  { "name": 'rate', "cpu": "6", "mem": "1024", "tap": { "name": "tap-h5", "ip": { "host": "10.10.10.12", "guest": "10.10.10.13" }, "mac": "06:aa:c0:a8:00:06" } },
  { "name": 'review', "cpu": "1", "mem": "1024", "tap": { "name": "tap-h6", "ip": { "host": "10.10.10.14", "guest": "10.10.10.15" }, "mac": "06:aa:c0:a8:00:07" } },
  { "name": 'attractions', "cpu": "1", "mem": "1024", "tap": { "name": "tap-h7", "ip": { "host": "10.10.10.16", "guest": "10.10.10.17" }, "mac": "06:aa:c0:a8:00:08" } },
  { "name": 'recommendation', "cpu": "1", "mem": "1024", "tap": { "name": "tap-h8", "ip": { "host": "10.10.10.18", "guest": "10.10.10.19" }, "mac": "06:aa:c0:a8:00:09" } },
  { "name": 'user', "cpu": "1", "mem": "1024", "tap": { "name": "tap-h9", "ip": { "host": "10.10.10.20", "guest": "10.10.10.21" }, "mac": "06:aa:c0:a8:00:10" } },
  { "name": 'reservation', "cpu": "18", "mem": "1024", "tap": { "name": "tap-h10", "ip": { "host": "10.10.10.22", "guest": "10.10.10.23" }, "mac": "06:aa:c0:a8:00:11" } },
  { "name": 'jaeger', "cpu": "1", "mem": "1024", "tap": { "name": "tap-h11", "ip": { "host": "10.10.10.24", "guest": "10.10.10.25" }, "mac": "06:aa:c0:a8:00:12" } },
  { "name": 'memcached-rate', "cpu": "1", "mem": "1024", "tap": { "name": "tap-h12", "ip": { "host": "10.10.10.26", "guest": "10.10.10.27" }, "mac": "06:aa:c0:a8:00:13" } },
  { "name": 'memcached-review', "cpu": "1", "mem": "1024", "tap": { "name": "tap-h13", "ip": { "host": "10.10.10.28", "guest": "10.10.10.29" }, "mac": "06:aa:c0:a8:00:14" } },
  { "name": 'memcached-profile', "cpu": "1", "mem": "1024", "tap": { "name": "tap-h14", "ip": { "host": "10.10.10.30", "guest": "10.10.10.31" }, "mac": "06:aa:c0:a8:00:15" } },
  { "name": 'memcached-reserve', "cpu": "2", "mem": "1024", "tap": { "name": "tap-h15", "ip": { "host": "10.10.10.32", "guest": "10.10.10.33" }, "mac": "06:aa:c0:a8:00:16" } },
  { "name": 'mongodb-geo', "cpu": "1", "mem": "1024", "tap": { "name": "tap-h16", "ip": { "host": "10.10.10.34", "guest": "10.10.10.35" }, "mac": "06:aa:c0:a8:00:17" } },
  { "name": 'mongodb-profile', "cpu": "1", "mem": "1024", "tap": { "name": "tap-h17", "ip": { "host": "10.10.10.36", "guest": "10.10.10.37" }, "mac": "06:aa:c0:a8:00:18" } },
  { "name": 'mongodb-rate', "cpu": "1", "mem": "1024", "tap": { "name": "tap-h18", "ip": { "host": "10.10.10.38", "guest": "10.10.10.39" }, "mac": "06:aa:c0:a8:00:19" } },
  { "name": 'mongodb-review', "cpu": "1", "mem": "1024", "tap": { "name": "tap-h19", "ip": { "host": "10.10.10.40", "guest": "10.10.10.41" }, "mac": "06:aa:c0:a8:00:20" } },
  { "name": 'mongodb-attractions', "cpu": "1", "mem": "1024", "tap": { "name": "tap-h20", "ip": { "host": "10.10.10.42", "guest": "10.10.10.43" }, "mac": "06:aa:c0:a8:00:21" } },
  { "name": 'mongodb-recommendation', "cpu": "1", "mem": "1024", "tap": { "name": "tap-h21", "ip": { "host": "10.10.10.44", "guest": "10.10.10.45" }, "mac": "06:aa:c0:a8:00:22" } },
  { "name": 'mongodb-reservation', "cpu": "1", "mem": "1024", "tap": { "name": "tap-h22", "ip": { "host": "10.10.10.46", "guest": "10.10.10.47" }, "mac": "06:aa:c0:a8:00:23" } },
  { "name": 'mongodb-user', "cpu": "1", "mem": "1024", "tap": { "name": "tap-h23", "ip": { "host": "10.10.10.48", "guest": "10.10.10.49" }, "mac": "06:aa:c0:a8:00:24" } },
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
    for vm in HOTEL_VMs:
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
    vm_config = next((vm for vm in HOTEL_VMs if vm['name'] == vm_name), None)
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
