
create_group() {
# create_group name is_system gid 
  if [ $(cat /etc/group | grep "$1" | wc -c) != 0 ]; then
    run_command "delgroup $1" "Error modifying group $1"
  fi

  if [ $2 = yes ]; then
    SYSTEM_GROUP="-S"
  fi
  if [ $# -gt 2 ]; then
    GROUP_GID="-g $3"
  fi  
  run_command "addgroup $GROUP_GID $SYSTEM_GROUP $1" "Error adding group $1"
  log_message INFO "Group <$1 ($(cat /etc/group | grep "$1"))>"
}

create_user() {
# create_user login uid gid sudo shell create_home is_system extra_grops
  COMMAND=""
  if [ $(cat /etc/passwd | grep "$1" | wc -c) != 0 ]; then
    run_command "deluser $1" "Error modifying user $1"
  fi

  COMMAND="adduser -D -s $5"
  if [ $6 != yes ]; then
    COMMAND="$COMMAND -H"
  fi
  if [ $7 = yes ]; then
    COMMAND="$COMMAND -S"
  fi
  COMMAND="$COMMAND $1 $3"  
  run_command "$COMMAND" "Error adding user $1"

  LOCAL_GROUPS="$3"
  if [ $4 = yes ]; then
     LOCAL_GROUPS="$LOCAL_GROUPS,wheel"
  fi
  if [ $# -gt 7 ]; then
    LOCAL_GROUPS="$LOCAL_GROUPS,$8"
  fi
  LOCAL_GROUPS=${LOCAL_GROUPS//,/ }
  log_message DEBUG "User groups: <$LOCAL_GROUPS>"
  for i in $LOCAL_GROUPS; do 
    run_command "addgroup $1 $i" "Error adding user $1 to group $I"
  done
  
  log_message READ "Set password for user <$1>"
  run_command "passwd $1" "Error adding user $1"
  log_message INFO "User <$1 ($(cat /etc/passwd | grep "$1"))>"
}
