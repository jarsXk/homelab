#!/bin/sh
# Initial setup for host, VM and LXC

INIT_REPO=https://raw.githubusercontent.com/jarsXk/homelab/main

. <(wget -qO- ${INIT_REPO}/host/linux/lib/lib-startup.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/lib/lib-helper.sh)

LOG_LEVEL=3
DRY_RUN=no
IGNORE_ERRORS=no
LOG_NAME="./init.log"

log_message INFO "Initial setup for Debian Metal, VM & LXC"

. <(wget -qO- ${INIT_REPO}/host/linux/lib/lib-checkroot.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/lib-init-env.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/lib-init-env-debian.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/lib-init-packages-debian.sh)
. <(wget -qO- ${INIT_REPO}/host/linux/init/lib-init-ssh.sh)

create_group() {
# create_group name is_system gid 
  if [ $(cat /etc/group | grep "$1" | wc -c) = 0 ]; then
    if [ $2 = yes ]; then
      SYSTEM_GROUP="--system"
    fi
    if [ $# -gt 2 ]; then
      GROUP_GID="-g $3"
    fi  
    run_command "groupadd $GROUP_GID $SYSTEM_GROUP $1" "Error adding group $1"
  else
    if [ $# -gt 2 ]; then
      run_command "groupmod -g $3 $1" "Error modifying group $1"
    fi
  fi
  log_message INFO "Group <$1 ($(cat /etc/group | grep "$1"))>"
}

create_user() {
# create_user login uid gid sudo shell create_home is_system extra_grops
  COMMAND=""
  
  if [ $(cat /etc/passwd | grep "$1" | wc -c) = 0 ]; then
    COMMAND="useradd --uid $2 --gid $3"
    if [ $# -gt 7 ] || [ $4 = yes ]; then
      if [ $# -gt 7 ] && [ $4 = no ]; then
        COMMAND="$COMMAND -G $8"
      elif [ $# -gt 7 ] && [ $4 = yes ]; then
        COMMAND="$COMMAND -G $8,sudo"
      elif [ $# -eq 7 ] && [ $4 = yes ]; then
        COMMAND="$COMMAND -G sudo"
      fi
    fi
    COMMAND="$COMMAND --shell $5"
    if [ $6 = yes ]; then
      COMMAND="$COMMAND --create-home"
    else
      COMMAND="$COMMAND --no-create-home"
    fi
    if [ $7 = yes ]; then
      COMMAND="$COMMAND --system"
    fi
    COMMAND="$COMMAND $1"
  
    run_command "$COMMAND" "Error adding user $1"
  else
    COMMAND="usermod --uid $2 --gid $3"
    if [ $# -gt 7 ] || [ $4 = yes ]; then
      if [ $# -gt 7 ] && [ $4 = no ]; then
        COMMAND="$COMMAND -a -G $8"
      elif [ $# -gt 7 ] && [ $4 = yes ]; then
        COMMAND="$COMMAND -a -G $8,sudo"
      elif [ $# -eq 7 ] && [ $4 = yes ]; then
        COMMAND="$COMMAND -a -G sudo"
      fi
    fi
  
    run_command "$COMMAND $1" "Error adding user $1"
  fi

  log_message READ "Set password for user <$1>"
  run_command "passwd $1" "Error adding user $1"
  log_message INFO "User <$1 ($(cat /etc/passwd | grep "$1"))>"
}

. <(wget -qO- ${INIT_REPO}/host/linux/init/lib-init-docker-debian.sh)

. <(wget -qO- ${INIT_REPO}/host/linux/init/lib-init-raw-debian.sh)

exit 0
