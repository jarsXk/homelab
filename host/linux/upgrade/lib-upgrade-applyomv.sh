
if [ $(command -v omv-rpc | wc -c) -gt 0 ]; then
  if [ $(cat /var/lib/openmediavault/dirtymodules.json | wc -c) -gt 3 ]; then
    log_message INFO "Reloading OMV modules"
    sleep 60s
    run_command "omv-rpc -u admin 'config' 'applyChanges' '{ \"modules\": $(cat /var/lib/openmediavault/dirtymodules.json),\"force\": true }'" "Error reloading OMV modules"
  else
    log_message INFO "No reloading OMV modules needed"
  fi
  else
    log_message INFO "OMV not installed"
fi