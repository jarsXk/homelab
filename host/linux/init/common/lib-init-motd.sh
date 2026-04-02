
# Setting motd
log_message INFO "Setting motd"
if [ -f /etc/motd ]; then
  run_command "mv /etc/motd /etc/motd.bak" "Error setting motd"
fi
run_command "mkdir -p /usr/share/figlet" "Error setting motd"
run_command "wget -O /usr/share/figlet/Tmplr.flf https://raw.githubusercontent.com/patorjk/figlet.js/refs/heads/main/fonts/Tmplr.flf" "Error setting motd"

if [ "$LINUX_DISTRO" = "debian" ]; then
  MOTD_PATH=/etc/profile.d/70-custom-motd
elif [ "$LINUX_DISTRO" = "alpine" ]; then
  MOTD_PATH=/etc/profile.d/70-custom-motd.sh
fi

if [ $NAS = yes ]; then
  run_command "wget -O /root/nas-ascii.txt ${INIT_REPO}/host/linux/init/download/motd/nas-ascii.txt" "Error setting motd"
  run_command "wget -O ${MOTD_PATH} ${INIT_REPO}/host/linux/init/download/motd/70-custom-motd.nas.sh" "Error setting motd"
elif [ $DOCKER = yes ]; then
  run_command "wget -O /root/docker-ascii.txt ${INIT_REPO}/host/linux/init/download/motd/docker-ascii.txt" "Error setting motd"
  run_command "wget -O ${MOTD_PATH} ${INIT_REPO}/host/linux/init/download/motd/70-custom-motd.docker.sh" "Error setting motd"
else
  run_command "wget -O ${MOTD_PATH} ${INIT_REPO}/host/linux/init/download/motd/70-custom-motd.sh" "Error setting motd"
fi
run_command "chmod ug+x ${MOTD_PATH}" "Error setting motd"