#!/bin/sh
# Initial setup for host, VM and LXC

INIT_REPO=https://raw.githubusercontent.com/jarsXk/homelab/main

. <(wget -qO- ${INIT_REPO}/host/linux/lib/lib-base.sh)

LOG_LEVEL=3
DRY_RUN=no
IGNORE_ERRORS=no
LOG_NAME="./init.log"
SERVER_ROLE=""

log_message INFO "Initial setup for Alpine Metal, VM & LXC"

. <(wget -qO- ${INIT_REPO}/host/linux/lib/lib-checkroot.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/distros/alpine/init/lib-init-env.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/distros/alpine/init/lib-init-env-alpine.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/distros/alpine/init/lib-init-packages-alpine.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/distros/alpine/init/lib-init-serverrole.sh)

. <(wget -qO- ${INIT_REPO}/host/linux/distros/alpine/init/lib-init-groupsusers-base-alpine.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/distros/alpine/init/lib-init-ssh.sh)

. <(wget -qO- ${INIT_REPO}/host/linux/distros/alpine/init/lib-init-groups.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/distros/alpine/init/lib-init-users.sh)

# timezone already set
. <(wget -qO- ${INIT_REPO}/host/linux/distros/alpine/init/lib-init-sshkey.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/distros/alpine/init/lib-init-docker-alpine.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/distros/alpine/init/lib-init-locale-alpine.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/distros/alpine/init/lib-init-motd.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/distros/alpine/init/lib-init-micro.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/distros/alpine/init/lib-init-aliases.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/distros/alpine/init/lib-init-mc.sh)
#. <(wget -qO- ${INIT_REPO}/host/linux/distros/alpine/init/lib-init-sudo-alpine.sh)
# usbmount not needed

. <(wget -qO- ${INIT_REPO}/host/linux/distros/alpine/init/lib-init-cleaning-alpine.sh)
log_message INFO "Initial setup finished"
run_command "${MOTD_PATH}" "Error"

if [ $DOCKER != no ]; then
  log_message INFO "!!! Restart is required !!!"
fi

exit 0
