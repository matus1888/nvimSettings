#!/bin/sh

IP_ADDRESS=$(grep -oP 'nameserver \K[0-9.]+' /etc/resolv.conf)

echo "IP Address of the host system: $IP_ADDRESS"
node proxy.js 11434 "$IP_ADDRESS" 11434
