
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
fi
