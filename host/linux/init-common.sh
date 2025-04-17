#!/bin/sh
# Initial setup for host, VM and LXC

LOG_LEVEL=3
DRY_RUN=no
IGNORE_ERRORS=no
LOG_NAME="./init-common.log"

log_message() {
# type message new_line
    IS_SHOW=no
    NEW_LINE=""

    if [ $# -gt 2 ]; then
        if [ $3 = "-n" ]; then
            NEW_LINE=$3
        fi
    fi
    if [ $1 = "ERROR" ] && [ $LOG_LEVEL -ge 1 ]; then IS_SHOW=yes; fi
    if [ $1 = "INFO" ]  && [ $LOG_LEVEL -ge 3 ]; then IS_SHOW=yes; fi
    if [ $1 = "DEBUG" ] && [ $LOG_LEVEL -ge 5 ]; then IS_SHOW=yes; fi
    if [ $1 = "READ" ];                          then IS_SHOW=yes; fi

    if [ $IS_SHOW = "yes" ]; then
        echo $NEW_LINE "$(date +'%Y-%m-%d %H:%M:%S')	$1	: $2" | tee -a $LOG_NAME
    fi
}

run_command () {
#  run_command command error_message output_to
    log_message DEBUG "> $1"
    if [ $DRY_RUN = no ]; then
        if [ $# -le 2 ]; then
            eval $1
        else
            eval "$1 >> $3"
        fi
        if [ $? -ne 0 ]; then
            log_message ERROR "$2"
            if [ $IGNORE_ERRORS != yes ]; then
                exit 1
            fi
        fi
    fi
}

create_group() {
# create_group name is_system gid 
    if [ $(cat /etc/group | grep "$1" | wc -c) = 0 ]; then
        if [ $2 = yes ]; then
            SYSTEM_GROUP="--system"
        fi
        if [ $# -gt 2 ]; then
            GROUP_GID="-g $3"
        fi
        if [ $LINUX_DISTRO = debian ] || [ $LINUX_DISTRO = ubuntu ]; then
            run_command "groupadd $GROUP_GID $SYSTEM_GROUP $1" "Error adding group $1"
        elif [ $LINUX_DISTRO = alpine ]; then
            run_command "addgroup $GROUP_GID $SYSTEM_GROUP $1" "Error adding group $1"
        fi
    else
        if [ $LINUX_DISTRO = debian ] || [ $LINUX_DISTRO = ubuntu ]; then
            if [ $# -gt 2 ]; then
                run_command "groupmod -g $3 $1" "Error modifying group $1"
            fi
        fi
    fi
    log_message INFO "Group <$1 ($(cat /etc/group | grep "$1"))>"
}

create_user() {
# create_user login uid gid sudo shell create_home is_system extra_grops
    COMMAND=""
    if [ $LINUX_DISTRO = debian ] || [ $LINUX_DISTRO = ubuntu ]; then
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
    elif [ $LINUX_DISTRO = alpine ]; then
        if [ $(cat /etc/passwd | grep "$1" | wc -c) = 0 ]; then
            COMMAND="adduser --uid $2 --ingroup $3 --disabled-password --shell $5"
            if [ $6 = no ]; then
                COMMAND="$COMMAND --no-create-home"
            fi
            if [ $7 = yes ]; then
                COMMAND="$COMMAND --system"
            fi
            COMMAND="$COMMAND $1"
            run_command "$COMMAND" "Error adding user $1"
        fi
        if [ $# -gt 7 ]; then
            GROUP_LIST=$(echo "$8" | sed "s/,/ /g")
            for i in $GROUP_LIST; do
                run_command "adduser $1 $i" "Error adding user $1 to group $i"
            done
        fi
        if [ $4 = yes ]; then
            run_command "adduser $1 wheel" "Error adding user $1 to group wheel"
        fi
    fi
    log_message READ "Set password for user <$1>"
    passwd $1
    log_message INFO "User <$1 ($(cat /etc/passwd | grep "$1"))>"
}

log_message INFO "Initial setup for VM & LXC"

# Checking sudo permissions
if [ $(id -u) -ne 0 ]; then
    log_message ERROR "Must run as root"
    if [ $IGNORE_ERRORS != yes ]; then
        exit 1
    fi
fi
log_message DEBUG "Running as root"

# Identifying linus distro
. /etc/os-release
LINUX_DISTRO=$ID
log_message INFO "Linux distro identified as <$LINUX_DISTRO>"
if [ $LINUX_DISTRO != debian ] && [ $LINUX_DISTRO != ubuntu ] && [ $LINUX_DISTRO != alpine ]; then
    log_message ERROR "Unsupported Linux distro"
    if [ $IGNORE_ERRORS != yes ]; then
        exit 1
    fi
fi

#Identifying ssh server
SSH_INSTALLED=no
if [ $LINUX_DISTRO = debian ] || [ $LINUX_DISTRO = ubuntu ]; then
    SSH_PACKAGES=$(apt list --installed "openssh-server" | wc -c)
else
    SSH_PACKAGES=$(apk list --installed "openssh-server" | wc -c)
fi
if [ $SSH_PACKAGES -gt 0 ]; then
    SSH_INSTALLED=yes
fi
log_message DEBUG "SSH server installed <$SSH_INSTALLED>"

# Updating
log_message INFO "Updating packages"
COMMAND="EMPTY"
if [ $LINUX_DISTRO = debian ] || [ $LINUX_DISTRO = ubuntu ]; then
    run_command "apt-get update" "Error updating"
    run_command "apt-get -y full-upgrade" "Error updating"
elif [ $LINUX_DISTRO = alpine ]; then
    run_command "apk update" "Error updating"
    run_command "apk upgrade --no-cache" "Error updating"
fi

# Uninstalling packages
PACKAGE_LIST="netcat-traditional"
if [ $LINUX_DISTRO = debian ] || [ $LINUX_DISTRO = ubuntu ]; then
    log_message INFO "Uninstalling packages <$PACKAGE_LIST>"
    run_command "apt -y purge $PACKAGE_LIST" "Error uninstalling"
    run_command "apt -y autoremove --purge" "Error uninstalling"
elif [ $LINUX_DISTRO = alpine ]; then
    log_message INFO "Uninstalling packages <$PACKAGE_LIST>"
    TMP_IGNORE_ERRORS=$IGNORE_ERRORS
    IGNORE_ERRORS=yes
    run_command "apk del $PACKAGE_LIST" "Error uninstalling"
    IGNORE_ERRORS=$TMP_IGNORE_ERRORS
fi

# Installing packages
PACKAGE_LIST="micro mc htop openssh-server openssh-client ca-certificates bash tzdata netcat-openbsd curl zstd"
if [ $LINUX_DISTRO = debian ] || [ $LINUX_DISTRO = ubuntu ]; then
    PACKAGE_LIST="$PACKAGE_LIST sudo util-linux nfs-common"
    log_message INFO "Installing packages <$PACKAGE_LIST> and <fastfetch>"
    run_command "apt-get -y install $PACKAGE_LIST" "Error installing"
    if [ $(dpkg --print-architecture) = amd64 ]; then
        DPKG_NAME="fastfetch-linux-$(dpkg --print-architecture).deb"
    elif [ $(dpkg --print-architecture) = arm64 ]; then
        DPKG_NAME="fastfetch-linux-$(uname -m).deb"
    fi
    log_message "DEBUG" "DPKG_NAME <$DPKG_NAME>"
    run_command "wget -O $DPKG_NAME https://github.com/fastfetch-cli/fastfetch/releases/latest/download/$DPKG_NAME" "Error installing"
    run_command "dpkg --install ./$DPKG_NAME" "Error installing"
elif [ $LINUX_DISTRO = alpine ]; then
    PACKAGE_LIST="$PACKAGE_LIST fastfetch doas lsblk bash-completion musl-locales nfs-utils"
    log_message INFO "Installing packages <$PACKAGE_LIST>"
    run_command "apk add --no-cache $PACKAGE_LIST" "Error installing"
fi

# Setting timezone
log_message INFO "Setting timezone"
if [ $LINUX_DISTRO = debian ] || [ $LINUX_DISTRO = ubuntu ]; then
    run_command "timedatectl set-timezone Europe/Moscow" "Error setting timezone"
elif [ $LINUX_DISTRO = alpine ]; then
    run_command "ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime" "Error setting timezone"
fi

# Setting sudo
log_message INFO "Setting sudo"
if [ $LINUX_DISTRO = alpine ]; then
    if [ ! -f /etc/doas.con ]; then
        run_command "touch /etc/doas.conf" "Error setting doas"
    fi
    run_command "echo permit persist :wheel as root" "Error setting doas" "/etc/doas.conf"

    run_command "wget --header 'Accept: application/vnd.github.v3.raw' -O /etc/profile.d/60-sudo-alias.sh https://api.github.com/repos/jarsXk/homelab/contents/host/linux/automated/60-sudo-alias.sh" "Error setting doas"
    run_command "chmod u+x /etc/profile.d/60-sudo-alias.sh" "Error setting doas"
fi

# Configuring SSH
if [ $SSH_INSTALLED = no ]; then
    log_message INFO "Configuring SSH server"
    create_group _ssh yes
    run_command "mkdir -p /etc/ssh/sshd_config.d" "Error configuring SSH server"
    run_command "wget --header 'Accept: application/vnd.github.v3.raw' -O /etc/ssh/sshd_config.d/custom.conf https://api.github.com/repos/jarsXk/homelab/contents/host/linux/automated/ssh/custom.conf" "Error configuring SSH server"
    if [ $LINUX_DISTRO = debian ] || [ $LINUX_DISTRO = ubuntu ]; then
        run_command "systemctl restart sshd" "Error configuring SSH server"
    elif [ $LINUX_DISTRO = alpine ]; then
        run_command "rc-update add sshd" "Error configuring SSH server"
        run_command "rc-service sshd start" "Error configuring SSH server"
    fi
fi

# Installing docker
while [ "$DOCKER" = "" ]; do
    log_message READ "Install Docker [y/n/c]> " -n
    read -r ANSWER_DOCKER
    case "$ANSWER_DOCKER" in
        [Yy]* )
            DOCKER=yes
        ;;
        [Nn]* )
            DOCKER=no
        ;;
        [Cc]* )
            log_message INFO "Canceled setup"
            exit 1
        ;;
        * )
            log_message INFO "Invalid input. Enter y, n, or c."
        ;;
    esac
done
log_message DEBUG "Selected install Docker <$DOCKER>"
if [ $DOCKER = yes ]; then
    log_message INFO "Installing Docker"
    create_group docker yes 988
    if [ $LINUX_DISTRO = debian ] || [ $LINUX_DISTRO = ubuntu ]; then
        run_command "install -m 0755 -d /etc/apt/keyrings" "Error installing docker"
        run_command "curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc" "Error installing docker"
        run_command "chmod a+r /etc/apt/keyrings/docker.asc" "Error installing docker"
        run_command "touch /etc/apt/sources.list.d/docker.list" "Error installing docker"
        CODENAME=$(. /etc/os-release && echo "$VERSION_CODENAME")
        if [ $LINUX_DISTRO = debian ]; then
            run_command "echo deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $CODENAME stable" "Error installing docker" "/etc/apt/sources.list.d/docker.list"
        elif [ $LINUX_DISTRO = ubuntu ]; then
            run_command "echo deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $CODENAME stable" "Error installing docker" "/etc/apt/sources.list.d/docker.list"
        fi    
        run_command "apt update" "Error installing docker"
        run_command "apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin" "Error installing docker"
    elif [ $LINUX_DISTRO = alpine ]; then
        run_command "apk add --no-cache docker" "Error installing docker"
        run_command "rc-update add docker default" "Error installing docker"
        run_command "service docker start" "Error installing docker"
    fi
    run_command "mkdir -p /etc/docker/" "Error installing docker"
    if [ -f /etc/docker/daemon.json ]; then
        run_command "mv /etc/docker/daemon.json /etc/docker/daemon.json.bak" "Error installing docker"
    fi
    run_command "wget --header 'Accept: application/vnd.github.v3.raw' -O /etc/docker/daemon.json https://api.github.com/repos/jarsXk/homelab/contents/host/linux/automated/docker/daemon.json" "Error installing docker"
    run_command "mkdir -p /srv/docker/injections" "Error installing docker"
    run_command "mkdir -p /srv/docker/volumes" "Error installing docker"
    run_command "mv /var/lib/docker/volumes/* /srv/docker/volumes/" "Error installing docker"
    run_command "echo /srv/docker/volumes /var/lib/docker/volumes none defaults,bind 0 0" "Error installing docker" "/etc/fstab"
    if [ $LINUX_DISTRO = debian ] || [ $LINUX_DISTRO = ubuntu ]; then
        run_command "systemctl daemon-reload" "Error installing docker"
    fi  
    run_command "mount -a" "Error installing docker"
    if [ $LINUX_DISTRO = debian ] || [ $LINUX_DISTRO = ubuntu ]; then
        run_command "systemctl restart docker" "Error installing docker"
    elif [ $LINUX_DISTRO = alpine ]; then
        run_command "service docker restart" "Error installing docker"
    fi
    if [ $LOG_LEVEL -ge 5 ]; then
        docker version
    fi
fi

# Reading role & location
while [ "$PUBLIC" = "" ]; do
    log_message READ "Setup public host [y/n/c]> " -n
    read -r ANSWER_PUBLIC
    case "$ANSWER_PUBLIC" in
        [Yy]* )
            PUBLIC=yes
        ;;
        [Nn]* )
            PUBLIC=no
        ;;
        [Cc]* )
            log_message INFO "Canceled setup"
            exit 1
        ;;
        * )
            log_message INFO "Invalid input. Enter y, n, or c."
        ;;
    esac
 done

log_message DEBUG "Selected public host <$PUBLIC>"
while [ "$LOCATION" = "" ]; do
    log_message READ "Location"
    log_message READ "  [1] kommunarka"
    log_message READ "  [2] vasilkovo"
    log_message READ "  [3] chanovo"
    log_message READ "  [4] shodnenskaya"
    log_message READ "  [0] other"
    log_message READ "Select [1-4/0/c]> " -n
    read -r ANSWER_LOCATION
    case "$ANSWER_LOCATION" in
        1)
            LOCATION=kommunarka
        ;;
        2)
            LOCATION=vasilkovo
        ;;
        3)
            LOCATION=chanovo
        ;;
        4)
            LOCATION=shodnenskaya
        ;;
        0)
            LOCATION=other
        ;;
        c)
            log_message INFO "Canceled setup"
            exit 1
        ;;
        * )
            log_message INFO "Invalid input. Enter 1-4, 0 or c."
        ;;
    esac
done
log_message DEBUG "Selected location <$LOCATION>"

# Creating groups
log_message INFO "Creating groups"
#                   name         is_system gid  
create_group    	family       no        2000
create_group	    lesha-group  no        2001 
if [ $PUBLIC = yes ] && [ $LOCATION = kommunarka ]; then
    create_group	lena-group   no        2002
fi
if [ $LOCATION = vasilkovo ]; then
    create_group	kostya-group no        2003
fi
if [ $PUBLIC = yes ] && [ $LOCATION = vasilkovo ]; then
    create_group	tanya-group  no        2004
    create_group	dima-group   no        2005
fi
if [ $PUBLIC = yes ] && [ $LOCATION = chanovo ]; then
    create_group	lena-group   no        2002
    create_group	yulia-group  no        2006
fi
if [ $PUBLIC = yes ] && [ $LOCATION = shodnenskaya ]; then
    create_group	lena-group   no        2002
    create_group	yulia-group  no        2006
fi

# Creating users
log_message INFO "Creating users"
DOCKER_GROUPS="docker,family,lesha-group"
FAMILY_GROUP=""
if [ $PUBLIC = yes ]; then
    FAMILY_GROUP=",family"
fi
# real users
#               login        uid  group    sudo shell             create_home is_system extra_groups
create_user     lesha        2001 users    yes  /bin/bash         yes         no        lesha-group,_ssh,family
if [ $PUBLIC = yes ] && [ $LOCATION = kommunarka ]; then
    create_user lena         2002 users    no   /bin/bash         yes         no        lena-group,_ssh,family
    DOCKER_GROUPS="$DOCKER_GROUPS,lena-group"
fi
if [ $LOCATION = vasilkovo ]; then
    create_user kostya       2003 users    yes  /bin/bash         yes         no        kostya-group,_ssh,family
    DOCKER_GROUPS="$DOCKER_GROUPS,kostya-group"
fi
if [ $PUBLIC = yes ] && [ $LOCATION = vasilkovo ]; then  
    create_user tanya        2004 users    no   /usr/sbin/nologin yes         no        tanya-group,family
    create_user dima         2005 users    no   /bin/bash         yes         no        dima-group,_ssh,family
    DOCKER_GROUPS="$DOCKER_GROUPS,tanya-group,dima-group"
fi
if [ $PUBLIC = yes ] && [ $LOCATION = chanovo ]; then
    create_user lena         2002 users    no   /bin/bash         yes         no        lena-group,_ssh,family
    create_user yulia        2006 users    no   /usr/sbin/nologin yes         no        yulia-group,family
    DOCKER_GROUPS="$DOCKER_GROUPS,lena-group,yulia-group"
fi
if [ $PUBLIC = yes ] && [ $LOCATION = shodnenskaya ]; then
    create_user lena         2002 users    no   /bin/bash         yes         no        lena-group,_ssh,family
    create_user yulia        2006 users    no   /usr/sbin/nologin yes         no        yulia-group,family
    DOCKER_GROUPS="$DOCKER_GROUPS,lena-group,yulia-group"
fi
# technical users
#               login        uid  group    sudo shell             create_home is_system extra_groups
if [ $DOCKER = yes ]; then
    create_user docker       200  users    no   /usr/sbin/nologin no          yes       $DOCKER_GROUPS
fi

# Adding ssh public key
log_message READ "Paste SSH public key [key/s/c] > " -n
read -r ANSWER_SSH_PUB
if [ "$ANSWER_PUB_KEY" = "s" ]; then
    SSH_PUB="-=skipped=-"
    log_message INFO "Skipped SSH public key setup"
elif [ "$ANSWER_PUB_KEY" = "c" ]; then
    log_message INFO "Canceled setup"
    exit 1
else
    SSH_PUB=$ANSWER_SSH_PUB
fi
log_message DEBUG "SSH public key <$SSH_PUB>"
if [ ! "$SSH_PUB" = "-=skipped=-" ]; then
    run_command "mkdir -p /home/lesha/.ssh" "Error adding SSH public key"
    if [ ! -f /home/lesha/.ssh/authorized_keys ]; then
        run_command "touch /home/lesha/.ssh/authorized_keys" "Error adding SSH public key"
    fi
    run_command "echo "$SSH_PUB"" "Error adding SSH public key" "/home/lesha/.ssh/authorized_keys"
    run_command "chown -R lesha:users /home/lesha/.ssh" "Error adding SSH public key"
fi

# Setting locale
log_message INFO "Setting locale"
if [ $LINUX_DISTRO = debian ] || [ $LINUX_DISTRO = ubuntu ]; then
    RU_LOCALE=$(locale --all-locales | grep ru_RU.utf8 | wc -c)
    if [ $RU_LOCALE -eq 0 ]; then
        run_command "locale-gen ru_RU.UTF-8" "Error setting locale"
    fi
    run_command "localectl set-locale LANG=ru_RU.UTF-8" "Error setting locale"
elif [ $LINUX_DISTRO = alpine ]; then
    run_command "mv /etc/profile.d/20locale.sh /etc/profile.d/20locale.sh.bak" "Error setting locale"
    run_command "wget --header 'Accept: application/vnd.github.v3.raw' -O /etc/profile.d/20locale.sh https://api.github.com/repos/jarsXk/homelab/contents/host/linux/automated/20locale.sh" "Error setting locale"
    run_command "chmod ug+x /etc/profile.d/20locale.sh" "Error setting locale"
fi

# Setting motd
log_message INFO "Setting motd"
if [ -f /etc/motd ]; then
    run_command "mv /etc/motd /etc/motd.bak" "Error setting motd"
fi
if [ $LINUX_DISTRO = debian ] || [ $LINUX_DISTRO = ubuntu ]; then
    MOTD_PATH=/etc/update-motd.d/
    CUSTOM_MOTD=70-custom-motd
elif [ $LINUX_DISTRO = alpine ]; then
    MOTD_PATH=/etc/profile.d/
    CUSTOM_MOTD=70-custom-motd.sh
fi
run_command "wget --header 'Accept: application/vnd.github.v3.raw' -O $MOTD_PATH$CUSTOM_MOTD https://api.github.com/repos/jarsXk/homelab/contents/host/linux/automated/70-custom-motd.sh" "Error setting motd"
run_command "chmod ug+x $MOTD_PATH$CUSTOM_MOTD" "Error setting motd"

# Configuring micro
run_command "mkdir -p /root/.config/micro" "Error configuring micro"
if [ -f /root/.config/micro/settings.json ]; then
    run_command "mv /root/.config/micro/settings.json /root/.config/micro/settings.json.bak" "Error configuring micro"
fi
run_command "wget --header 'Accept: application/vnd.github.v3.raw' -O /root/.config/micro/settings.json https://api.github.com/repos/jarsXk/homelab/contents/host/linux/automated/micro/settings.json" "Error configuring micro"
run_command "mkdir -p /home/lesha/.config/micro" "Error configuring micro"
run_command "chown -R lesha:users /home/lesha/.config/micro" "Error configuring micro"
if [ -f /home/lesha/.config/micro/settings.json ]; then
    run_command "mv /home/lesha/.config/micro/settings.json /home/lesha/.config/micro/settings.json.bak" "Error configuring micro"
fi
run_command "cp /root/.config/micro/settings.json /home/lesha/.config/micro/settings.json" "Error configuring micro"
run_command "chown -R lesha:users /home/lesha/.config/micro" "Error configuring micro"

# Configuring MC
log_message INFO "Configuring MC"
run_command "mkdir -p /root/.config/mc" "Error configuring MC"
if [ -f /root/.config/mc/panels.ini ]; then
    run_command "mv /root/.config/mc/panels.ini /root/.config/mc/panels.ini.bak" "Error configuring MC"
fi
run_command "wget --header 'Accept: application/vnd.github.v3.raw' -O /root/.config/mc/panels.ini https://api.github.com/repos/jarsXk/homelab/contents/host/linux/automated/mc/panels.ini" "Error configuring MC"
run_command "mkdir -p /home/lesha/.config/mc" "Error configuring MC"
if [ -f /home/lesha/.config/mc/panels.ini ]; then
    run_command "mv /home/lesha/.config/mc/panels.ini /home/lesha/.config/mc/panels.ini.bak" "Error configuring MC"
fi
run_command "cp /root/.config/mc/panels.ini /home/lesha/.config/mc/panels.ini" "Error configuring MC"
run_command "chown -R lesha:users /home/lesha/.config/mc" "Error configuring MC"

# Configuring colors
if [ $LINUX_DISTRO = alpine ]; then
    log_message INFO "Configuring colors"
    if [ -f /etc/profile.d/color_prompt.sh.disabled ]; then
        run_command "ln -s /etc/profile.d/color_prompt.sh.disabled /etc/profile.d/color_prompt.sh" "Error setting colors"
        run_command "chmod u+x /etc/profile.d/color_prompt.sh" "Error setting colors"
    fi
fi

# Cleaning
log_message INFO "Cleaning"
if [ $LINUX_DISTRO = debian ] || [ $LINUX_DISTRO = ubuntu ]; then
    run_command "apt-get autoremove --yes" "Error cleaning"
    run_command "apt-get clean autoclean" "Error cleaning"
    run_command "rm -rf /var/lib/apt/lists/*" "Error cleaning"
    run_command "apt-get update" "Error cleaning"
elif [ $LINUX_DISTRO = alpine ]; then
    run_command "apk cache clean" "Error cleaning"
fi

log_message INFO "Initial setup finished"
run_command "fastfetch --pipe false" "Error"
exit 0
