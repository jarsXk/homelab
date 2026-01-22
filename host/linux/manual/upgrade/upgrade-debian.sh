#!/bin/sh
# Initial setup for host, VM and LXC

INIT_REPO=https://raw.githubusercontent.com/jarsXk/homelab/main/host/linux

. <(wget -qO- ${INIT_REPO}/lib/lib-startup.sh)
. <(wget -qO- ${INIT_REPO}/lib/lib-helper.sh)

log_message INFO "Upgrade script for Debian/OMV"

. <(wget -qO- ${INIT_REPO}/manual/upgrade/lib-upgrade-snap.sh)

. <(wget -qO- ${INIT_REPO}/manual/upgrade/lib-upgrade-apt.sh)

. <(wget -qO- ${INIT_REPO}/manual/upgrade/lib-upgrade-applyomv.sh)

. <(wget -qO- ${INIT_REPO}/manual/upgrade/lib-upgrade-reboot.sh)

exit 0
