#!/bin/sh

IP_ADDRESS=$(grep -oP 'nameserver \K[0-9.]+' /etc/resolv.conf)

echo "IP Address of the host system: $IP_ADDRESS"
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
echo script_directory = "$SCRIPT_DIR"
node "${SCRIPT_DIR}/fromWSLProxy.js" 11434 "$IP_ADDRESS" 11434
