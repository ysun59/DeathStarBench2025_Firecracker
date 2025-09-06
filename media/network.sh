#!/bin/bash

# Enable ip forwarding
sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
iptables -P FORWARD ACCEPT

# This tries to determine the name of the host network interface to forward
# VM's outbound network traffic through. If outbound traffic doesn't work,
# double check this returns the correct interface!
HOST_IFACE=$(ip -j route list default |jq -r '.[0].dev')

# Set up microVM internet access
echo "Using host interface: $HOST_IFACE"
iptables -t nat -D POSTROUTING -o "$HOST_IFACE" -j MASQUERADE || true
iptables -t nat -A POSTROUTING -o "$HOST_IFACE" -j MASQUERADE
