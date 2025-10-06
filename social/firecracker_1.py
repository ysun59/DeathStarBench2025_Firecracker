#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
from string import Template

WORKING_DIR = os.path.dirname(os.path.abspath(__file__))

SOCIAL_VMs = [
  { "name": 'social-graph-service', "cpu": "1", "mem": "1024", "tap": { "name": "tap-s1", "ip": { "host": "10.10.11.2", "guest": "10.10.11.3" }, "mac": "06:aa:c0:a8:01:01" } },
  { "name": 'social-graph-mongodb', "cpu": "1", "mem": "1024", "tap": { "name": "tap-s2", "ip": { "host": "10.10.11.4", "guest": "10.10.11.5" }, "mac": "06:aa:c0:a8:01:02" } },
  { "name": 'social-graph-redis', "cpu": "1", "mem": "1024", "tap": { "name": "tap-s3", "ip": { "host": "10.10.11.6", "guest": "10.10.11.7" }, "mac": "06:aa:c0:a8:01:03" } },
  { "name": 'home-timeline-redis', "cpu": "4", "mem": "1024", "tap": { "name": "tap-s4", "ip": { "host": "10.10.11.8", "guest": "10.10.11.9" }, "mac": "06:aa:c0:a8:01:04" } },
  { "name": 'compose-post-service', "cpu": "8", "mem": "1024", "tap": { "name": "tap-s5", "ip": { "host": "10.10.11.10", "guest": "10.10.11.11" }, "mac": "06:aa:c0:a8:01:05" } },
  { "name": 'post-storage-service', "cpu": "2", "mem": "1024", "tap": { "name": "tap-s6", "ip": { "host": "10.10.11.12", "guest": "10.10.11.13" }, "mac": "06:aa:c0:a8:01:06" } },
  { "name": 'post-storage-memcached', "cpu": "1", "mem": "1024", "tap": { "name": "tap-s7", "ip": { "host": "10.10.11.14", "guest": "10.10.11.15" }, "mac": "06:aa:c0:a8:01:07" } },
  { "name": 'post-storage-mongodb', "cpu": "2", "mem": "1024", "tap": { "name": "tap-s8", "ip": { "host": "10.10.11.16", "guest": "10.10.11.17" }, "mac": "06:aa:c0:a8:01:08" } },
  { "name": 'user-timeline-service', "cpu": "2", "mem": "1024", "tap": { "name": "tap-s9", "ip": { "host": "10.10.11.18", "guest": "10.10.11.19" }, "mac": "06:aa:c0:a8:01:09" } },
  { "name": 'user-timeline-redis', "cpu": "1", "mem": "1024", "tap": { "name": "tap-s10", "ip": { "host": "10.10.11.20", "guest": "10.10.11.21" }, "mac": "06:aa:c0:a8:01:10" } },
  { "name": 'user-timeline-mongodb', "cpu": "8", "mem": "1024", "tap": { "name": "tap-s11", "ip": { "host": "10.10.11.22", "guest": "10.10.11.23" }, "mac": "06:aa:c0:a8:01:11" } },
  { "name": 'url-shorten-service', "cpu": "1", "mem": "1024", "tap": { "name": "tap-s12", "ip": { "host": "10.10.11.24", "guest": "10.10.11.25" }, "mac": "06:aa:c0:a8:01:12" } },
  { "name": 'url-shorten-memcached', "cpu": "1", "mem": "1024", "tap": { "name": "tap-s13", "ip": { "host": "10.10.11.26", "guest": "10.10.11.27" }, "mac": "06:aa:c0:a8:01:13" } },
  { "name": 'url-shorten-mongodb', "cpu": "2", "mem": "1024", "tap": { "name": "tap-s14", "ip": { "host": "10.10.11.28", "guest": "10.10.11.29" }, "mac": "06:aa:c0:a8:01:14" } },
  { "name": 'user-service', "cpu": "1", "mem": "1024", "tap": { "name": "tap-s15", "ip": { "host": "10.10.11.30", "guest": "10.10.11.31" }, "mac": "06:aa:c0:a8:01:15" } },
  { "name": 'user-memcached', "cpu": "1", "mem": "1024", "tap": { "name": "tap-s16", "ip": { "host": "10.10.11.32", "guest": "10.10.11.33" }, "mac": "06:aa:c0:a8:01:16" } },
  { "name": 'user-mongodb', "cpu": "1", "mem": "1024", "tap": { "name": "tap-s17", "ip": { "host": "10.10.11.34", "guest": "10.10.11.35" }, "mac": "06:aa:c0:a8:01:17" } },
  { "name": 'media-service', "cpu": "1", "mem": "1024", "tap": { "name": "tap-s18", "ip": { "host": "10.10.11.36", "guest": "10.10.11.37" }, "mac": "06:aa:c0:a8:01:18" } },
  { "name": 'media-memcached', "cpu": "1", "mem": "1024", "tap": { "name": "tap-s19", "ip": { "host": "10.10.11.38", "guest": "10.10.11.39" }, "mac": "06:aa:c0:a8:01:19" } },
  { "name": 'media-mongodb', "cpu": "1", "mem": "1024", "tap": { "name": "tap-s20", "ip": { "host": "10.10.11.40", "guest": "10.10.11.41" }, "mac": "06:aa:c0:a8:01:20" } },
  { "name": 'text-service', "cpu": "4", "mem": "1024", "tap": { "name": "tap-s21", "ip": { "host": "10.10.11.42", "guest": "10.10.11.43" }, "mac": "06:aa:c0:a8:01:21" } },
  { "name": 'unique-id-service', "cpu": "1", "mem": "1024", "tap": { "name": "tap-s22", "ip": { "host": "10.10.11.44", "guest": "10.10.11.45" }, "mac": "06:aa:c0:a8:01:22" } },
  { "name": 'user-mention-service', "cpu": "2", "mem": "1024", "tap": { "name": "tap-s23", "ip": { "host": "10.10.11.46", "guest": "10.10.11.47" }, "mac": "06:aa:c0:a8:01:23" } },
  { "name": 'home-timeline-service', "cpu": "2", "mem": "1024", "tap": { "name": "tap-s24", "ip": { "host": "10.10.11.48", "guest": "10.10.11.49" }, "mac": "06:aa:c0:a8:01:24" } },
  { "name": 'nginx-thrift', "cpu": "8", "mem": "1024", "tap": { "name": "tap-s25", "ip": { "host": "10.10.11.50", "guest": "10.10.11.51" }, "mac": "06:aa:c0:a8:01:25" } },
  { "name": 'media-frontend', "cpu": "1", "mem": "1024", "tap": { "name": "tap-s26", "ip": { "host": "10.10.11.52", "guest": "10.10.11.53" }, "mac": "06:aa:c0:a8:01:26" } },
  { "name": 'jaeger-agent', "cpu": "2", "mem": "1024", "tap": { "name": "tap-s27", "ip": { "host": "10.10.11.54", "guest": "10.10.11.55" }, "mac": "06:aa:c0:a8:01:27" } },
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
    for vm in SOCIAL_VMs:
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
    vm_config = next((vm for vm in SOCIAL_VMs if vm['name'] == vm_name), None)
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
