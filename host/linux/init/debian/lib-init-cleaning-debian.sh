
# Cleaning
log_message INFO "Cleaning"
run_command "$PACKAGEMANAGER autoremove --yes" "Error cleaning"
run_command "$PACKAGEMANAGER clean autoclean" "Error cleaning"
run_command "rm -rf /var/lib/apt/lists/*" "Error cleaning"
run_command "$PACKAGEMANAGER update" "Error cleaning"
