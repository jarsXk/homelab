
# Configuring aliases
if [ -f /root/.bash_aliases ]; then
  run_command "cp /root/.bash_aliases /root/.bash_aliases.bak" "Error configuring aliases"
fi
run_command "wget -O /root/.bash_aliases ${INIT_REPO}/host/linux/init/download/bash/.bash_aliases" "Error configuring aliases"
run_command "wget -O /root/.bash_export ${INIT_REPO}/host/linux/init/download/bash/.bash_export" "Error configuring aliases"
if [ -f /home/lesha/.bash_aliases ]; then
  run_command "cp /home/lesha/.bash_aliases /home/lesha/.bash_aliases.bak" "Error configuring aliases"
fi
run_command "wget -O /home/lesha/.bash_aliases ${INIT_REPO}/host/linux/init/download/bash/.bash_aliases" "Error configuring aliases"
run_command "wget -O /home/lesha/.bash_export ${INIT_REPO}/host/linux/init/download/bash/.bash_export" "Error configuring aliases"
run_command "chown lesha:users /home/lesha/.bash_aliases" "Error configuring aliases"
run_command "chmod go-x /home/lesha/.bash_aliases" "Error configuring aliases"
run_command "chown lesha:users /home/lesha/.bash_export" "Error configuring aliases"
run_command "chmod go-x /home/lesha/.bash_export" "Error configuring aliases"
