
# Cleaning
log_message INFO "Cleaning"
run_command "apt autoremove --yes" "Error cleaning"
run_command "apt clean autoclean" "Error cleaning"
run_command "rm -rf /var/lib/apt/lists/*" "Error cleaning"
run_command "apt update" "Error cleaning"
