
# Updating
log_message INFO "Updating packages"
run_command "apt update" "Error updating"
run_command "apt -y full-upgrade" "Error updating"

# Installing packages
log_message "DEBUG" "DEBIAN_VERSION <$DISTRO_VERSION>"
PACKAGE_LIST="micro mc htop curl wget zstd unzip sudo figlet dnsutils imagemagick iperf3 fastfetch"
log_message INFO "Installing packages <$PACKAGE_LIST>"
run_command "apt -y install $PACKAGE_LIST" "Error installing"
