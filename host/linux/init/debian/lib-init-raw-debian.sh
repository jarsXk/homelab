# Initial setup for host, VM and LXC

# Creating users
log_message INFO "Creating users"
DOCKER_GROUPS="docker,lesha-group"
if [ "$SERVER_ROLE" = "nas" ]; then
  DOCKER_GROUPS="$DOCKER_GROUPS,family"
fi
FAMILY_GROUP=""
if [ $NAS = yes ]; then
  FAMILY_GROUP=",family"
fi
# real users
#               login      uid  group    sudo shell             create_home is_system extra_groups
create_user     lesha      2001 users    yes  /bin/bash         yes         no        lesha-group,_ssh$FAMILY_GROUP
if [ "$SERVER_ROLE" = "nas" ] && [ $LOCATION = kommunarka ]; then
  create_user lena         2002 users    no   /bin/bash         yes         no        lena-group,_ssh$FAMILY_GROUP
  DOCKER_GROUPS="$DOCKER_GROUPS,lena-group"
fi
if [ $LOCATION = vasilkovo ]; then
  create_user kostya       2003 users    yes  /bin/bash         yes         no        kostya-group,_ssh$FAMILY_GROUP
  DOCKER_GROUPS="$DOCKER_GROUPS,kostya-group"
fi
if [ "$SERVER_ROLE" = "nas" ] && [ $LOCATION = vasilkovo ]; then  
  create_user tanya        2004 users    no   /usr/sbin/nologin yes         no        tanya-group$FAMILY_GROUP
  create_user dima         2005 users    no   /bin/bash         yes         no        dima-group,_ssh$FAMILY_GROUP
  DOCKER_GROUPS="$DOCKER_GROUPS,tanya-group,dima-group"
fi
if [ "$SERVER_ROLE" = "nas" ] && [ $LOCATION = chanovo ]; then
  create_user lena         2002 users    no   /bin/bash         yes         no        lena-group,_ssh$FAMILY_GROUP
  create_user yulia        2006 users    no   /usr/sbin/nologin yes         no        yulia-group$FAMILY_GROUP
  DOCKER_GROUPS="$DOCKER_GROUPS,lena-group,yulia-group"
fi
if [ $LOCATION = yasenevof ]; then
  create_user kostya       2003 users    yes  /bin/bash         yes         no        kostya-group,_ssh$FAMILY_GROUP
  DOCKER_GROUPS="$DOCKER_GROUPS,kostya-group"
fi
if [ "$SERVER_ROLE" = "nas" ] && [ $LOCATION = shodnenskaya ]; then
  create_user lena         2002 users    no   /bin/bash         yes         no        lena-group,_ssh$FAMILY_GROUP
  create_user yulia        2006 users    no   /usr/sbin/nologin yes         no        yulia-group$FAMILY_GROUP
  DOCKER_GROUPS="$DOCKER_GROUPS,lena-group,yulia-group"
fi
# technical users
#             login        uid  group    sudo shell             create_home is_system extra_groups
if [ $DOCKER = yes ]; then
  create_user docker       1999 users    no   /usr/sbin/nologin no          yes       $DOCKER_GROUPS
fi
if [ "$SERVER_ROLE" = "nas" ]; then
  create_user internal     1998 users    no   /usr/sbin/nologin no          yes
fi
# create_user amnezia      1997 users    yes  /bin/bash         yes         yes

# Deleting group "lesha"
if [ $(getent group lesha) ]; then
  run_command "groupdel lesha" "Error deleting group lesha"
fi

# Setting locale
log_message INFO "Setting locale"
run_command "dpkg-reconfigure locales" "Error setting locale"

# Updating sudoers file
if [ $DOCKER = snapd ]; then
  log_message INFO "Updating sudoers file"
  run_command "wget -O /etc/sudoers.d/10-snappath ${INIT_REPO}/host/linux/init/download/10-snappath" "Error updating sudoers file"
fi

# Setting motd
log_message INFO "Setting motd"
if [ -f /etc/motd ]; then
  run_command "mv /etc/motd /etc/motd.bak" "Error setting motd"
fi

run_command "mkdir -p /usr/share/figlet" "Error setting motd"
run_command "wget -O /usr/share/figlet/ANSI_Shadow.flf https://raw.githubusercontent.com/xero/figlet-fonts/refs/heads/main/ANSI%20Shadow.flf" "Error setting motd"

MOTD_PATH=/etc/update-motd.d/70-custom-motd
CUSTOM_MOTD=70-custom-motd
if [ $NAS = yes ]; then
  run_command "wget -O /root/nas-ascii.txt ${INIT_REPO}/host/linux/init/download/motd/nas-ascii.txt" "Error setting motd"
  run_command "wget -O /etc/update-motd.d/70-custom-motd ${INIT_REPO}/host/linux/init/download/motd/70-custom-motd.nas.sh" "Error setting motd"
elif [ $DOCKER = yes ]; then
  run_command "wget -O /root/docker-ascii.txt ${INIT_REPO}/host/linux/init/download/motd/docker-ascii.txt" "Error setting motd"
  run_command "wget -O /etc/update-motd.d/70-custom-motd ${INIT_REPO}/host/linux/init/download/motd/70-custom-motd.docker.sh" "Error setting motd"
else
  run_command "wget -O /etc/update-motd.d/70-custom-motd ${INIT_REPO}/host/linux/init/download/motd/70-custom-motd.sh" "Error setting motd"
fi
run_command "chmod ug+x /etc/update-motd.d/70-custom-motd" "Error setting motd"

# Configuring micro
run_command "mkdir -p /root/.config/micro" "Error configuring micro"
if [ -f /root/.config/micro/settings.json ]; then
  run_command "mv /root/.config/micro/settings.json /root/.config/micro/settings.json.bak" "Error configuring micro"
fi
run_command "wget -O /root/.config/micro/settings.json ${INIT_REPO}/host/linux/init/download/micro/settings.json" "Error configuring micro"
run_command "mkdir -p /home/lesha/.config/micro" "Error configuring micro"
if [ -f /home/lesha/.config/micro/settings.json ]; then
  run_command "mv /home/lesha/.config/micro/settings.json /home/lesha/.config/micro/settings.json.bak" "Error configuring micro"
fi
run_command "cp /root/.config/micro/settings.json /home/lesha/.config/micro/settings.json" "Error configuring micro"
run_command "chown -R lesha:users /home/lesha/.config" "Error configuring micro"
run_command "chmod -R go-x /home/lesha/.config" "Error configuring micro"

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

# Configuring MC
log_message INFO "Configuring MC"
run_command "mkdir -p /root/.config/mc" "Error configuring MC"
if [ -f /root/.config/mc/panels.ini ]; then
  run_command "mv /root/.config/mc/panels.ini /root/.config/mc/panels.ini.bak" "Error configuring MC"
fi
run_command "wget -O /root/.config/mc/panels.ini ${INIT_REPO}/host/linux/init/download/mc/panels.ini" "Error configuring MC"
run_command "mkdir -p /home/lesha/.config/mc" "Error configuring MC"
if [ -f /home/lesha/.config/mc/panels.ini ]; then
  run_command "mv /home/lesha/.config/mc/panels.ini /home/lesha/.config/mc/panels.ini.bak" "Error configuring MC"
fi
run_command "cp /root/.config/mc/panels.ini /home/lesha/.config/mc/panels.ini" "Error configuring MC"
run_command "chown -R lesha:users /home/lesha/.config" "Error configuring MC"
run_command "chmod -R go-x /home/lesha/.config" "Error configuring MC"

# Install usbmount
if [ $PHYSICAL = yes ]; then
  CUR_FOLDER=$(pwd)
  run_command "wget -O /root/mine.zip https://github.com/clach04/automount-usb/archive/refs/heads/mine.zip" "Error installing usbmount"
  run_command "cd /root" "Error installing usbmount"
  run_command "unzip /root/mine.zip" "Error installing usbmount"
  run_command "cd /root/automount-usb-mine" "Error installing usbmount"
  run_command "bash /root/automount-usb-mine/CONFIGURE.sh" "Error installing usbmount"
  run_command "cd $CUR_FOLDER" "Error installing usbmount"
  run_command "rm /etc/systemd/system/usb-mount@.service" "Error installing usbmount"
  run_command "wget -O /etc/systemd/system/usb-mount@.service ${INIT_REPO}/host/linux/init/download/usbmount/usb-mount@.service" "Error installing usbmount"
  run_command "mv /usr/local/bin/usb-mount.sh /usr/local/sbin/" "Error installing usbmount"
  run_command "mv /root/automount-usb-mine /usr/local/sbin/usbmount" "Error installing usbmount"
  run_command "cp /etc/systemd/system/usb-mount@.service /usr/local/sbin/usbmount/" "Error installing usbmount"
  run_command "rm /root/mine.zip" "Error installing usbmount"
fi

# Cleaning
log_message INFO "Cleaning"
run_command "apt-get autoremove --yes" "Error cleaning"
run_command "apt-get clean autoclean" "Error cleaning"
run_command "rm -rf /var/lib/apt/lists/*" "Error cleaning"
run_command "apt-get update" "Error cleaning"

log_message INFO "Initial setup finished"
run_command "/etc/update-motd.d/70-custom-motd" "Error"
