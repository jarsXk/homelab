#!/bin/sh
# Initial setup for host, VM and LXC

INIT_REPO=https://raw.githubusercontent.com/jarsXk/homelab/main

. <(wget -qO- ${INIT_REPO}/host/linux/lib/lib-startup.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/lib/lib-helper.sh)

LOG_LEVEL=3
DRY_RUN=no
IGNORE_ERRORS=no
LOG_NAME="./init.log"

log_message INFO "Initial setup for Debian Metal, VM & LXC"

. <(wget -qO- ${INIT_REPO}/host/linux/lib/lib-checkroot.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/lib-init-env.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/lib-init-env-debian.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/lib-init-packages-debian.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/lib-init-ssh.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/lib-init-raw-debian.sh)

exit 0
