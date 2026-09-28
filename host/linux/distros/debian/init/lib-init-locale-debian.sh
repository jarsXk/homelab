
# Setting locale
log_message INFO "Setting locale"
run_command "dpkg-reconfigure locales" "Error setting locale"
