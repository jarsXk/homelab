
# Uninstalling packages
PACKAGE_LIST="netcat-traditional"
log_message INFO "Uninstalling packages <$PACKAGE_LIST>"
run_command "$PACKAGEMANAGER -y purge $PACKAGE_LIST" "Error uninstalling"
run_command "$PACKAGEMANAGER -y autoremove --purge" "Error uninstalling"

# Updating
log_message INFO "Updating packages"
run_command "$PACKAGEMANAGER update" "Error updating"
run_command "$PACKAGEMANAGER -y full-upgrade" "Error updating"

# Installing packages
PACKAGE_LIST="micro mc htop openssh-server openssh-client ca-certificates bash tzdata netcat-openbsd curl wget zstd unzip sudo util-linux figlet dnsutils imagemagick locales"
if [ $DEBIAN_VERSION >= 13 ]; then
  PACKAGE_LIST="$PACKAGE_LIST fastfetch"
fi
log_message INFO "Installing packages <$PACKAGE_LIST>"
run_command "$PACKAGEMANAGER -y install $PACKAGE_LIST" "Error installing"
if [ $DEBIAN_VERSION < 13 ] ; then
  if [ $(dpkg --print-architecture) = amd64 ]; then
    DPKG_NAME="fastfetch-linux-$(dpkg --print-architecture).deb"
  elif [ $(dpkg --print-architecture) = arm64 ]; then
    DPKG_NAME="fastfetch-linux-$(uname -m).deb"
  fi
  log_message "DEBUG" "DPKG_NAME <$DPKG_NAME>"
  log_message INFO "Installing additional packages <fastfetch>"
  run_command "wget -O $DPKG_NAME https://github.com/fastfetch-cli/fastfetch/releases/latest/download/$DPKG_NAME" "Error installing"
  run_command "dpkg --install ./$DPKG_NAME" "Error installing"
fi