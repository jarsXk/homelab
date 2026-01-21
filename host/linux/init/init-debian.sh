#!/bin/sh
# Initial setup for host, VM and LXC

. lib-env.sh
. lib-helper.sh

log_message INFO "Initial setup for VM & LXC"

. lib-check.sh
if [ $LINUX_DISTRO == debian ] || [ $LINUX_DISTRO == ubuntu ]; then
  DEBIAN_VERSION=$VERSION_ID
fi

#. lib-start-debian.sh

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

#. lib-finish-debian.sh

exit 0
