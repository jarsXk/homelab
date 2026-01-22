
# Checking sudo permissions
if [ $(id -u) -ne 0 ]; then
  log_message ERROR "Must run as root"
  if [ $IGNORE_ERRORS != yes ]; then
    exit 1
  fi
fi
log_message DEBUG "Running as root"
