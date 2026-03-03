
# Configuring MC
log_message INFO "Configuring MC"
run_command "mkdir -p /root/.config/mc" "Error configuring MC"
if [ -f /root/.config/mc/panels.ini ]; then
  run_command "mv /root/.config/mc/panels.ini /root/.config/mc/panels.ini.bak" "Error configuring MC"
fi
run_command "wget -O /root/.config/mc/panels.ini ${INIT_REPO}/host/linux/init/download/mc/panels.ini" "Error configuring MC"
run_command "mkdir -p /home/lesha/.config/mc" "Error configuring MC"
if [ -f /home/lesha/.config/mc/panels.ini ]; then
  run_command "mv /home/lesha/.config/mc/panels.ini /home/lesha/.config/mc/panels.ini.bak" "Error configuring MC"
fi
run_command "cp /root/.config/mc/panels.ini /home/lesha/.config/mc/panels.ini" "Error configuring MC"
run_command "chown -R lesha:users /home/lesha/.config" "Error configuring MC"
run_command "chmod -R go-x /home/lesha/.config" "Error configuring MC"
