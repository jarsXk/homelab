#!/bin/sh
# Initial setup for host, VM and LXC

INIT_REPO=https://raw.githubusercontent.com/jarsXk/homelab/main

. <(wget -qO- ${INIT_REPO}/host/linux/lib/lib-base.sh)

LOG_LEVEL=3
DRY_RUN=no
IGNORE_ERRORS=no
LOG_NAME="./init.log"
SERVER_ROLE="proxmox"

log_message INFO "Initial setup for Debian Metal, VM & LXC"

. <(wget -qO- ${INIT_REPO}/host/linux/lib/lib-checkroot.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/common/lib-init-env.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/debian/lib-init-env-debian.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/debian/lib-init-packages-proxmox.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/common/lib-init-serverrole.sh)

. <(wget -qO- ${INIT_REPO}/host/linux/init/debian/lib-init-groups-base-debian.sh)
# no user groups creation
. <(wget -qO- ${INIT_REPO}/host/linux/init/debian/lib-init-users-base-debian.sh)

. <(wget -qO- ${INIT_REPO}/host/linux/init/common/lib-init-ssh.sh)
# no timezone set
. <(wget -qO- ${INIT_REPO}/host/linux/init/debian/lib-init-docker-debian.sh)

. <(wget -qO- ${INIT_REPO}/host/linux/init/debian/lib-init-raw-debian.sh)

exit 0
