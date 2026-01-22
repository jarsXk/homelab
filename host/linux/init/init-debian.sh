#!/bin/sh
# Initial setup for host, VM and LXC

INIT_REPO=https://raw.githubusercontent.com/jarsXk/homelab/main/host/linux

. <(wget -qO- ${INIT_REPO}/init/lib-env.sh)
. <(wget -qO- ${INIT_REPO}/init/lib-helper.sh)

log_message INFO "Initial setup for VM & LXC"

. <(wget -qO- ${INIT_REPO}/init/lib-check.sh)
if [ $LINUX_DISTRO == debian ] || [ $LINUX_DISTRO == ubuntu ]; then
  DEBIAN_VERSION=$VERSION_ID
fi

. <(wget -qO - ${INIT_REPO}/init/lib-raw-debian.sh)

exit 0
