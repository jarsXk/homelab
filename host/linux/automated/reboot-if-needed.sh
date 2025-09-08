#!/bin/bash

# Checking sudo permissions
if [ $(id -u) -ne 0 ]; then
  echo "Must run as root"
  exit 1
fi

if [ -f /var/run/reboot-required ]; then
  echo "Reboot is required..."
  reboot
fi
