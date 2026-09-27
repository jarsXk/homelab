
# Installing docker
while [ "$DOCKER" = "" ]; do
  log_message READ "Install Docker native (d), no install (n) [d/n/c]> " -n
  read -r ANSWER_DOCKER
  case "$ANSWER_DOCKER" in
    [Dd]* )
      DOCKER=native
    ;;
    [Nn]* )
      DOCKER=no
    ;;
    [Cc]* )
      log_message INFO "Canceled setup"
      exit 1
    ;;
    * )
      log_message INFO "Invalid input. Enter d, n, or c."
    ;;
  esac
done
log_message DEBUG "Selected install Docker <$DOCKER>"

if [ $DOCKER != no ]; then
  log_message INFO "Installing Docker"
  create_group docker yes 199

  DOCKER_CONFIG_PATH=/etc/docker
  run_command "apk add docker" "Error installing docker"   
  run_command "mkdir -p ${DOCKER_CONFIG_PATH}" "Error installing docker"
  if [ -f ${DOCKER_CONFIG_PATH}/daemon.json ]; then
    run_command "mv ${DOCKER_CONFIG_PATH}/daemon.json ${DOCKER_CONFIG_PATH}/daemon.json.bak" "Error installing docker" 
  fi
  run_command "wget -O ${DOCKER_CONFIG_PATH}/daemon.json ${INIT_REPO}/host/linux/init/download/docker/daemon.json" "Error installing docker"


  run_command "rc-update add docker default" "Error installing docker"
  run_command "service docker start" "Error installing docker"
  sleep 2s
  PREV_IGNORE_ERRORS=$IGNORE_ERRORS
  IGNORE_ERRORS=yes
  run_command "docker version" "Error installing docker"
  IGNORE_ERRORS=$PREV_IGNORE_ERRORS
fi