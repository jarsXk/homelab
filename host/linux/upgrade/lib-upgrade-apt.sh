
PREV_FRONTEND=$DEBIAN_FRONTEND
export DEBIAN_FRONTEND=noninteractive

if [ $(command -v omv-upgrade | wc -c) -gt 0 ]; then
  log_message INFO "Upgrading OMV"
  run_command "omv-upgrade" "Error upgrading OMV"
else
  log_message INFO "Upgrading APT"
  run_command "apt update" "Error updating APT"
  run_command "apt upgrade -y" "Error upgrading APT"
fi

export DEBIAN_FRONTEND=$PREV_FRONTEND

log_message INFO "Cleaning APT"
run_command "apt autoremove -y" "Error cleaning APT"
