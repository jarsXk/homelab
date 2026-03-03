
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