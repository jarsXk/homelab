
if [ -f /var/run/reboot-required ]; then
  echo "Rebooting..."
  reboot
else
  echo "No reboot needed"
fi
