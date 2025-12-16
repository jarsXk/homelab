#!/bin/bash

# Checking sudo permissions
if [ $(id -u) -ne 0 ]; then
  echo "Must run as root"
  exit 1
fi

if [ -f /var/run/reboot-required ]; then
  echo "Applying OMV changes. Sleepeing 60s..."
  sleep 60s
  jq -e '.. | select(length == 0)' /var/lib/openmediavault/dirtymodules.json || /usr/sbin/omv-rpc -u admin "config" "applyChanges" "{ \"modules\": $(cat /var/lib/openmediavault/dirtymodules.json),\"force\": true }"
else
  echo "No OMV changes."
fi
