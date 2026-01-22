
if [ $(command -v snap | wc -c) -gt 0 ]; then
  log_message INFO "Refreshing SNAPs"
  run_command "snap refresh" "Error refreshing SNAPs"
else
  log_message INFO "Snap is not installed"
fi
