
# Add community repo
run_command "setup-apkrepos -c" "Error adding community repo"

# Uninstalling packages

# Updating
log_message INFO "Updating packages"
run_command "apk update" "Error updating"
run_command "apk upgrade" "Error updating"

# Installing packages
log_message "DEBUG" "ALPINE_VERSION <$DISTRO_VERSION>"
PACKAGE_LIST="micro mc htop openssh-server ca-certificates bash tzdata curl wget zstd unzip sudo util-linux figlet bind-tools imagemagick musl-locales iperf3 fastfetch"
log_message INFO "Installing packages <$PACKAGE_LIST>"
run_command "apk add $PACKAGE_LIST" "Error installing"
