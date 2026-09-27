
if [ $LINUX_DISTRO != alpine ]; then
  log_message ERROR "Unsupported Linux distro"
  if [ $IGNORE_ERRORS != yes ]; then
    exit 1
  fi
fi

SERVICERESTART="rc-service"
SERVICERESTART_FOOTER="restart"