
# Setting locale
log_message INFO "Setting locale"
if [ -f /etc/profile.d/30locale.sh ]; then
  run_command "mv /etc/profile.d/30locale.sh /etc/profile.d/30locale.bak" "Error setting locale"
fi
run_command "wget -O /etc/profile.d/30locale.sh ${INIT_REPO}/host/linux/init/download/30locale.sh" "Error setting locale"
run_command "chmod ug+x /etc/profile.d/30locale.sh" "Error setting locale"
