#!/bin/sh
# Initial setup for host, VM and LXC

INIT_REPO=https://raw.githubusercontent.com/jarsXk/homelab/main/host/linux

. <(wget -qO- ${INIT_REPO}/lib/lib-startup.sh)
. <(wget -qO- ${INIT_REPO}/lib/lib-helper.sh)

log_message INFO "Initial setup for VM & LXC"

. <(wget -qO- ${INIT_REPO}/lib/lib-checkroot.sh)
. <(wget -qO- ${INIT_REPO}/manual/init/lib-init-env.sh)

. <(wget -qO- ${INIT_REPO}/manual/init/lib-init-env-debian.sh)
. <(wget -qO- ${INIT_REPO}/init/lib-init-packages-debian.sh)
. <(wget -qO- ${INIT_REPO}/init/lib-init-ssh.sh)
. <(wget -qO- ${INIT_REPO}/init/lib-init-raw-debian.sh)

exit 0
