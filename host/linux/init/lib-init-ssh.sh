
#Identifying ssh server
SSH_INSTALLED=no
SSH_PACKAGES=$($PACKAGEMANAGER list --installed "openssh-server" | wc -c)
if [ $SSH_PACKAGES -gt 0 ]; then
  SSH_INSTALLED=yes
fi
log_message DEBUG "SSH server installed <$SSH_INSTALLED>"

# Configuring SSH
if [ $SSH_INSTALLED = no ]; then
  log_message INFO "Configuring SSH server"
  create_group _ssh yes
  run_command "mkdir -p /etc/ssh/sshd_config.d" "Error configuring SSH server"
  run_command "wget -O /etc/ssh/sshd_config.d/custom.conf ${INIT_REPO}/host/linux/init/download/ssh/custom.conf" "Error configuring SSH server"
  run_command "$SERVICERESTART sshd" "Error configuring SSH server"
fi