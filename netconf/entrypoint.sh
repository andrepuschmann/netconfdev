#!/bin/bash

cleanup() {
    echo "Container stopped, exporting running config .."
    sysrepocfg --export -d running
}

PRELOAD_CONFIG=/config/default_config.xml
if [ -f "$PRELOAD_CONFIG" ]; then
    echo "Importing $PRELOAD_CONFIG .."
    sysrepocfg --import $PRELOAD_CONFIG --datastore startup -f xml -m _3gpp-common-managed-element
else
    echo "Skipping config pre-load."
fi

# Trap SIGTERM
trap 'cleanup' SIGTERM

echo "Starting netconf server .."
/usr/local/sbin/netopeer2-server -v3 -d

# Wait
wait $!