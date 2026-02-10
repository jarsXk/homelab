
# Installing docker
while [ "$DOCKER" = "" ]; do
  log_message READ "Install Docker native (d), snapd (s), no install (n) [d/s/n/c]> " -n
  read -r ANSWER_DOCKER
  case "$ANSWER_DOCKER" in
    [Dd]* )
      DOCKER=native
    ;;
    [Ss]* )
      DOCKER=snapd
    ;;
    [Nn]* )
      DOCKER=no
    ;;
    [Cc]* )
      log_message INFO "Canceled setup"
      exit 1
    ;;
    * )
      log_message INFO "Invalid input. Enter d, s, n, or c."
    ;;
  esac
done
log_message DEBUG "Selected install Docker <$DOCKER>"

if [ $DOCKER != no ]; then
  log_message INFO "Installing Docker"
  create_group docker yes 199

  if [ $DOCKER = native ]; then
    DOCKER_CONFIG_PATH=/etc/docker

    run_command "wget -O- https://get.docker.com | sh" "Error installing docker"   
  elif [ $DOCKER = snapd ]; then
    DOCKER_CONFIG_PATH=/var/snap/docker/current/config

    PACKAGE_LIST="snapd"
    log_message INFO "Installing additional packages <$PACKAGE_LIST>"
    run_command "apt-get -y install $PACKAGE_LIST" "Error installing docker"
    SNAP_LIST="snapd docker"
    log_message INFO "Installing snaps <$SNAP_LIST>"
    run_command "snap install $SNAP_LIST" "Error installing docker"
  fi

  run_command "mkdir -p ${DOCKER_CONFIG_PATH}" "Error installing docker"
  if [ -f ${DOCKER_CONFIG_PATH}/daemon.json ]; then
    run_command "mv ${DOCKER_CONFIG_PATH}/daemon.json ${DOCKER_CONFIG_PATH}/daemon.json.bak" "Error installing docker" 
  fi
  run_command "wget -O ${DOCKER_CONFIG_PATH}/daemon.json ${INIT_REPO}/host/linux/init/download/docker/daemon.json" "Error installing docker"

  if [ $DOCKER = native ]; then
    run_command "systemctl restart docker" "Error installing docker"
    sleep 2s
    run_command "docker version" "Error installing docker"
  elif [ $DOCKER = snapd ]; then
    run_command "snap connect docker:removable-media" "Error installing docker"
    run_command "snap restart docker" "Error installing docker"
    sleep 2s
    run_command "/snap/bin/docker version" "Error installing docker"
  fi
fi