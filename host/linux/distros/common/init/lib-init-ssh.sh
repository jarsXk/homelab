
# Configuring SSH
log_message INFO "Configuring SSH server"
create_group _ssh yes
run_command "mkdir -p /etc/ssh/sshd_config.d" "Error configuring SSH server"
run_command "wget -O /etc/ssh/sshd_config.d/custom.conf ${INIT_REPO}/host/linux/init/download/ssh/custom.conf" "Error configuring SSH server"
run_command "$SERVICERESTART sshd $SERVICERESTART_FOOTER" "Error configuring SSH server"