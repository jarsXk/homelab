
if [ $LINUX_DISTRO != debian ]; then
  log_message ERROR "Unsupported Linux distro"
  if [ $IGNORE_ERRORS != yes ]; then
    exit 1
  fi
fi

if [ $LINUX_DISTRO == debian ]; then
  DEBIAN_VERSION=$VERSION_ID
fi

PACKAGEMANAGER=apt
SERVICERESTART="systemctl restart"