#!/bin/sh
# Initial setup for host, VM and LXC

INIT_REPO=https://raw.githubusercontent.com/jarsXk/homelab/main

. <(wget -qO- ${INIT_REPO}/host/linux/lib/lib-base.sh)

LOG_LEVEL=3
DRY_RUN=no
IGNORE_ERRORS=no
LOG_NAME="./init.log"
SERVER_ROLE=""

log_message INFO "Initial setup for Debian Metal, VM & LXC"

. <(wget -qO- ${INIT_REPO}/host/linux/lib/lib-checkroot.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/common/lib-init-env.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/debian/lib-init-env-debian.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/debian/lib-init-packages-debian.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/common/lib-init-serverrole.sh)

. <(wget -qO- ${INIT_REPO}/host/linux/init/debian/lib-init-groupsusers-base-debian.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/common/lib-init-ssh.sh)

. <(wget -qO- ${INIT_REPO}/host/linux/init/common/lib-init-groups.sh)
# Deleting group "lesha"
if [ $(getent group lesha) ]; then
  run_command "groupdel lesha" "Error deleting group lesha"
fi
. <(wget -qO- ${INIT_REPO}/host/linux/init/common/lib-init-users.sh)

. <(wget -qO- ${INIT_REPO}/host/linux/init/debian/lib-init-timezone-debian.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/debian/lib-init-docker-debian.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/debian/lib-init-locale-debian.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/debian/lib-init-motd.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/common/lib-init-micro.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/common/lib-init-aliases.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/common/lib-init-mc.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/debian/lib-init-usbmount-debian.sh)

. <(wget -qO- ${INIT_REPO}/host/linux/init/debian/lib-init-cleaning-debian.sh)
log_message INFO "Initial setup finished"
run_command "/etc/update-motd.d/70-custom-motd" "Error"

exit 0
