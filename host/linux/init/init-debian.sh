#!/bin/sh
# Initial setup for host, VM and LXC

INIT_REPO=https://raw.githubusercontent.com/jarsXk/homelab/main/host/linux

wget -O - ${INIT_REPO}/init/lib-env.sh | . /dev/stdin
wget -O - ${INIT_REPO}/init/lib-helper.sh | . /dev/stdin
echo 123 $LOG_NAME
log_message INFO "Initial setup for VM & LXC"

wget -O - ${INIT_REPO}/init/lib-check.sh | . /dev/stdin
if [ $LINUX_DISTRO == debian ] || [ $LINUX_DISTRO == ubuntu ]; then
  DEBIAN_VERSION=$VERSION_ID
fi

# wget -O - ${INIT_REPO}/init/lib-start-debian.sh | . /dev/stdin

#Identifying ssh server
SSH_INSTALLED=no
if [ $LINUX_DISTRO = debian ] || [ $LINUX_DISTRO = ubuntu ]; then
  SSH_PACKAGES=$(apt list --installed "openssh-server" | wc -c)
else
  SSH_PACKAGES=$(apk list --installed "openssh-server" | wc -c)
fi
if [ $SSH_PACKAGES -gt 0 ]; then
  SSH_INSTALLED=yes
fi
log_message DEBUG "SSH server installed <$SSH_INSTALLED>"

# wget -O - ${INIT_REPO}/init/lib-finish-debian.sh | . /dev/stdin

exit 0
