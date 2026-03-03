
# Configuring micro
run_command "mkdir -p /root/.config/micro" "Error configuring micro"
if [ -f /root/.config/micro/settings.json ]; then
  run_command "mv /root/.config/micro/settings.json /root/.config/micro/settings.json.bak" "Error configuring micro"
fi
run_command "wget -O /root/.config/micro/settings.json ${INIT_REPO}/host/linux/init/download/micro/settings.json" "Error configuring micro"
run_command "mkdir -p /home/lesha/.config/micro" "Error configuring micro"
if [ -f /home/lesha/.config/micro/settings.json ]; then
  run_command "mv /home/lesha/.config/micro/settings.json /home/lesha/.config/micro/settings.json.bak" "Error configuring micro"
fi
run_command "cp /root/.config/micro/settings.json /home/lesha/.config/micro/settings.json" "Error configuring micro"
run_command "chown -R lesha:users /home/lesha/.config" "Error configuring micro"
run_command "chmod -R go-x /home/lesha/.config" "Error configuring micro"
