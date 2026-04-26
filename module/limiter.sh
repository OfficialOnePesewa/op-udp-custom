#!/bin/bash
# Bandwidth limiter for UDP Custom

LIMITER_SCRIPT="/etc/limiter.sh"
tc qdisc del dev eth0 root 2>/dev/null
tc qdisc del dev eth0 ingress 2>/dev/null

# Set limits: adjust rate as needed (default 200Mbit)
tc qdisc add dev eth0 root handle 1: htb default 30
tc class add dev eth0 parent 1: classid 1:1 htb rate 200mbit
tc class add dev eth0 parent 1:1 classid 1:10 htb rate 200mbit ceil 200mbit
tc filter add dev eth0 protocol ip parent 1:0 prio 1 u32 match ip dst 0.0.0.0/0 flowid 1:10

# Log execution
echo "$(date) - Limiter applied" >> /var/log/limiter.log
