
# Cleaning
log_message INFO "Cleaning"
run_command "apk cache clean" "Error cleaning"
run_command "apk update" "Error cleaning"
