#!/bin/bash

LOG_LEVEL=3
DRY_RUN=no
IGNORE_ERRORS=no

#LOG_NAME="/home/lesha/backup-btrfs.log"
LOG_NAME="/var/log/backup-docker.log"
MOUNT_DIR="/mnt/terra-backup"
EXTERNAL_DIR="terra-nas.internal:/export/backup/Vesta"
#BACKUP_DIR="/home/lesha/tmp-backup"
BACKUP_DIR="$MOUNT_DIR/docker"
FILE_PREFIX="$(hostname)-backup"
KEEP_DAYS=30
FOLDER="/srv/docker"
#FOLDER="/home/lesha/tmp-source"

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
            if [ $# -le 3 ]; then
                eval $1 >> $3
            else
                eval $1 $4 $3
            fi
        fi
        if [ $? -ne 0 ]; then
            log_message ERROR "$2"
            if [ $IGNORE_ERRORS != yes ]; then
                exit 1
            fi
        fi
    fi
}

purge_old () {
    log_message DEBUG "Keep days <$KEEP_DAYS>"
    if [ $KEEP_DAYS -gt 0 ]; then
        run_command "find $BACKUP_DIR -maxdepth 1 -type f -mtime +$KEEP_DAYS -name $FILE_PREFIX* -delete" "Error purging old files"
    else
        log_message INFO "Purging disabled"
    fi
}

log_message INFO "*DOCKER* backup starting"

# Checking sudo permissions
if [ $(id -u) -ne 0 ]; then
    log_message ERROR "Must run as root"
    if [ $IGNORE_ERRORS != yes ]; then
        exit 1
    fi
fi
log_message DEBUG "Running as root"

# date
CURDATE=$(date +"%Y-%m-%d_%H-%M-%S")
log_message DEBUG "Current date $CURDATE"

log_message INFO "Creating/checking backup dir"
if [ -n "$MOUNT_DIR" ]; then
    run_command "mkdir -p $MOUNT_DIR" "Error creating mount dir"
    run_command "mount -t nfs $EXTERNAL_DIR $MOUNT_DIR" "Error mounting nfs share"
fi
run_command "mkdir -p $BACKUP_DIR" "Error creating backup dir"

# backup extra folders
if [ -n "$FOLDER" ]; then
    log_message DEBUG "Folder <$FOLDER>"  
    # saving subvolume info
    run_command "tar -I 'zstd -3' --exclude=ipc-socket -cf $BACKUP_DIR/$FILE_PREFIX-$CURDATE.docker.tar.zst --one-file-system $FOLDER" "Error zstd backup" 
fi   

run_command "chmod 664 $BACKUP_DIR/$FILE_PREFIX-$CURDATE.*" "Error updating permissions"
# Purging old backups
log_message INFO "Purging old backups"
run_command "touch $BACKUP_DIR/$FILE_PREFIX-$CURDATE.*" "Error updating backup date-time"
purge_old

if [ -n "$MOUNT_DIR" ]; then
    run_command "umount $MOUNT_DIR" "Error umounting nfs share"
fi

log_message INFO "*DOCKER* backup complete"
exit 0
