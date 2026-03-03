
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