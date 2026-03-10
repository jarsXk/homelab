
# Uninstalling packages
#PACKAGE_LIST=""
#log_message INFO "Uninstalling packages <$PACKAGE_LIST>"
#run_command "apt -y purge $PACKAGE_LIST" "Error uninstalling"
#run_command "apt -y autoremove --purge" "Error uninstalling"

# Updating
log_message INFO "Updating packages"
run_command "apt update" "Error updating"
run_command "apt -y full-upgrade" "Error updating"

# Installing packages
log_message "DEBUG" "DEBIAN_VERSION <$DISTRO_VERSION>"
PACKAGE_LIST="micro mc htop openssh-server ca-certificates bash tzdata curl wget zstd unzip sudo util-linux figlet dnsutils imagemagick locales iperf3"
if [ "$DISTRO_VERSION" -ge 13 ]; then
  PACKAGE_LIST="$PACKAGE_LIST fastfetch"
fi
log_message INFO "Installing packages <$PACKAGE_LIST>"
run_command "apt -y install $PACKAGE_LIST" "Error installing"
if [ "$DISTRO_VERSION" -lt 13 ] ; then
  ARCHITECTURE=$(dpkg --print-architecture)
  log_message "DEBUG" "ARCHITECTURE <$ARCHITECTURE>"
  if [ $ARCHITECTURE = amd64 ]; then
    DPKG_NAME="fastfetch-linux-$(dpkg --print-architecture).deb"
  elif [ $ARCHITECTURE = arm64 ]; then
    DPKG_NAME="fastfetch-linux-$(uname -m).deb"
  fi
  log_message "DEBUG" "DPKG_NAME <$DPKG_NAME>"
  log_message INFO "Installing additional packages <fastfetch>"
  run_command "wget -O $DPKG_NAME https://github.com/fastfetch-cli/fastfetch/releases/latest/download/$DPKG_NAME" "Error installing"
  run_command "dpkg --install ./$DPKG_NAME" "Error installing"
fi