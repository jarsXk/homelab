#!/bin/sh
# Initial setup for host, VM and LXC

INIT_REPO=https://raw.githubusercontent.com/jarsXk/homelab/main/host/linux

. <(wget -qO- ${INIT_REPO}/lib/lib-startup.sh)
. <(wget -qO- ${INIT_REPO}/lib/lib-helper.sh)

log_message INFO "Upgrade script for plain Debian"

. <(wget -qO- ${INIT_REPO}/manual/upgrade/lib-upgrade-apt.sh)

exit 0
