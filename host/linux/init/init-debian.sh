#!/bin/sh
# Initial setup for host, VM and LXC

source lib-env.sh
source lib-helper.sh

log_message INFO "Initial setup for VM & LXC"

# Checking sudo permissions
if [ $(id -u) -ne 0 ]; then
  log_message ERROR "Must run as root"
  if [ $IGNORE_ERRORS != yes ]; then
    exit 1
  fi
fi
log_message DEBUG "Running as root"

# Identifying linus distro
. /etc/os-release
LINUX_DISTRO=$ID
log_message INFO "Linux distro identified as <$LINUX_DISTRO>"
if [ $LINUX_DISTRO != debian ] && [ $LINUX_DISTRO != ubuntu ]; then
  log_message ERROR "Unsupported Linux distro"
  if [ $IGNORE_ERRORS != yes ]; then
    exit 1
  fi
else
  DEBIAN_VERSION=$VERSION_ID
fi

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

exit 0
