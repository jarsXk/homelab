
# Setting timezone
log_message INFO "Setting timezone"
run_command "timedatectl set-timezone Europe/Moscow" "Error setting timezone"