
# Adding ssh public key
log_message READ "Paste SSH public key [key/s/c] > " -n
read -r ANSWER_SSH_PUB
if [ "$ANSWER_PUB_KEY" = "s" ]; then
  SSH_PUB="-=skipped=-"
  log_message INFO "Skipped SSH public key setup"
elif [ "$ANSWER_PUB_KEY" = "c" ]; then
  log_message INFO "Canceled setup"
  exit 1
else
  SSH_PUB=$ANSWER_SSH_PUB
fi
log_message DEBUG "SSH public key <$SSH_PUB>"
if [ ! "$SSH_PUB" = "-=skipped=-" ]; then
  run_command "mkdir -p /home/lesha/.ssh" "Error adding SSH public key"
  if [ ! -f /home/lesha/.ssh/authorized_keys ]; then
    run_command "touch /home/lesha/.ssh/authorized_keys" "Error adding SSH public key"
  fi
  run_command "echo "$SSH_PUB"" "Error adding SSH public key" "/home/lesha/.ssh/authorized_keys"
  run_command "chown -R lesha:users /home/lesha/.ssh" "Error adding SSH public key"
  run_command "chmod -R go-x /home/lesha/.ssh" "Error adding SSH public key"
fi