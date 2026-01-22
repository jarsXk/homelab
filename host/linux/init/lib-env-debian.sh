
PACKAGEMANAGER=apt
SERVICERESTART="systemctl restart"

if [ $LINUX_DISTRO == debian ]; then
  DEBIAN_VERSION=$VERSION_ID
fi