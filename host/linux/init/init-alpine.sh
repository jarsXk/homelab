#!/bin/sh
# Initial setup for host, VM and LXC

INIT_REPO=https://raw.githubusercontent.com/jarsXk/homelab/main

. <(wget -qO- ${INIT_REPO}/host/linux/lib/lib-base.sh)

LOG_LEVEL=5
DRY_RUN=yes
IGNORE_ERRORS=no
LOG_NAME="./init.log"
SERVER_ROLE=""

log_message INFO "Initial setup for Alpine Metal, VM & LXC"

. <(wget -qO- ${INIT_REPO}/host/linux/lib/lib-checkroot.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/common/lib-init-env.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/alpine/lib-init-env-alpine.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/alpine/lib-init-packages-alpine.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/common/lib-init-serverrole.sh)

. <(wget -qO- ${INIT_REPO}/host/linux/init/alpine/lib-init-groupsusers-base-alpine.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/common/lib-init-ssh.sh)

. <(wget -qO- ${INIT_REPO}/host/linux/init/common/lib-init-groups.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/common/lib-init-users.sh)

# timezone already set
. <(wget -qO- ${INIT_REPO}/host/linux/init/alpine/lib-init-docker-alpine.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/debian/lib-init-locale-alpine.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/debian/lib-init-motd.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/common/lib-init-micro.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/common/lib-init-aliases.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/common/lib-init-mc.sh)
# usbmount not needed

. <(wget -qO- ${INIT_REPO}/host/linux/init/debian/lib-init-cleaning-debian.sh)
log_message INFO "Initial setup finished"
run_command "/etc/update-motd.d/70-custom-motd.sh" "Error"

exit 0
