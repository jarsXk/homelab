
if [ -f /var/run/reboot-required ]; then
  log_message INFO "Rebooting..."
  reboot
else
  log_message INFO "No reboot needed"
fi
