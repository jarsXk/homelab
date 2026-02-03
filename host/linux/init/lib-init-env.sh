
# Identifying linus distro
. /etc/os-release
LINUX_DISTRO=$ID
log_message INFO "Linux distro identified as <$LINUX_DISTRO>"