#!/bin/sh
# Example

if [ $(netcat -vz vesta.internal 22 2>&1 | grep succeeded | wc -c) -eq 0 ]; then
    exit 1
fi
if [ $(netcat -vz vesta-docker.internal 22 2>&1 | grep succeeded | wc -c) -eq 0 ]; then
    exit 1
fi
if [ $(netcat -vz vesta-hplip.internal 22 2>&1 | grep succeeded | wc -c) -eq 0 ]; then
    exit 1
fi

exit 0