#!/bin/bash

LOG_LEVEL=3
DRY_RUN=no
IGNORE_ERRORS=no

#LOG_NAME="/home/lesha/backup-btrfs.log"
LOG_NAME="/var/log/backup-btrfs.log"
MOUNT_DIR="/mnt/tmp-root"
#BACKUP_DIR="/home/lesha/tmp-backup"
BACKUP_DIR="/srv/data/io-backup/Europa/system"
MOUNT_SERVICE="srv-remotemount-io_backup.mount"
FILE_PREFIX="$(hostname)-backup"
KEEP_DAYS=100
THREADS=2
EXCL_SUBVOLUMES="@ @rootfs @var-tmp @var-lib-docker @.snapshots"
FOLDER_LIST="/root /home"

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

log_message INFO "Host <$(hostname)>"
log_message INFO "*FULL* backup starting"

# Checking sudo permissions
if [ $(id -u) -ne 0 ]; then
    log_message ERROR "Must run as root"
    if [ $IGNORE_ERRORS != yes ]; then
        exit 1
    fi
fi
log_message DEBUG "Running as root"

log_message INFO "*ROOT* backup starting"

# date
CURDATE=$(date +"%Y-%m-%d_%H-%M-%S")
log_message DEBUG "Current date $CURDATE"

# clean apt-get cache to save space
log_message INFO "Clearing apt"
run_command "apt-get clean" "Error cleaning apt"

log_message INFO "Creating/checking backup dir"
if [ ! -d $BACKUP_DIR ]; then
  if [ -n $MOUNT_SERVICE ]; then
    BACKUP_MOUNTED=$(systemctl is-active $MOUNT_SERVICE >/dev/null 2>&1 && echo YES || echo NO)
    log_message DEBUG "Backup mounted (1): $BACKUP_MOUNTED"
    if [ $BACKUP_MOUNTED = YES ]; then
      run_command "mkdir -p $BACKUP_DIR" "Error creating backup dir"
    else
      run_command "sudo systemctl start $MOUNT_SERVICE" "Error creating backup dir"
      BACKUP_MOUNTED=$(systemctl is-active $MOUNT_SERVICE >/dev/null 2>&1 && echo YES || echo NO)
      log_message DEBUG "Backup mounted (2): $BACKUP_MOUNTED"
      if [ $BACKUP_MOUNTED = YES ]; then
        run_command "mkdir -p $BACKUP_DIR" "Error creating backup dir"
      else
        log_message ERROR "Could not mount backup dir"
        exit 1
      fi
    fi
  else
    run_command "mkdir -p $BACKUP_DIR" "Error creating backup dir"
  fi
fi

# get device file for /
DEVICE_FILE=$(awk '$5 == "/" { print $10 }' /proc/self/mountinfo)
if [ $DEVICE_FILE = "/dev/root" ]; then
    # try alternate method to get root device if /dev/root is returned
    DEVICE_FILE=$(findmnt -n / | awk '{ print $2 }')
fi
if [ $DEVICE_FILE = "/dev/root" ] || [ -z $DEVICE_FILE ]; then
    log_message ERROR "Could not determine root device file"
    exit 1
fi
log_message DEBUG "Device file <$DEVICE_FILE>"

ROOT="/dev/$(lsblk -no pkname $DEVICE_FILE)"
if [ -z $ROOT ]; then
    log_message ERROR "Could not determine root device"
    exit 1
fi
log_message DEBUG "Root drive <$ROOT>"

# save helpful information
log_message INFO "Save fdisk output for $ROOT"
run_command "fdisk --list $ROOT" "Error getting fdisk info" "$BACKUP_DIR/$FILE_PREFIX-$CURDATE.fdisk"
log_message INFO "Save blkid output"
run_command "blkid" "Error getting blkid info" "$BACKUP_DIR/$FILE_PREFIX-$CURDATE.blkid"

# calculate partition table size to accommodate GPT and MBR.
log_message DEBUG "Calculate partition table size to accommodate GPT and MBR"
PART_TYPE=$(blkid --probe $ROOT | cut -d \" -f4)
log_message DEBUG "Partition type <$PART_TYPE>"
if [ $PART_TYPE = "gpt" ]; then
    NUM_PARTS=$(parted -m $ROOT print | tail -n1 | cut -b1)
    log_message DEBUG "Num partitions <$NUM_PARTS>"
    GRUBPARST_BS_CALC=$(((128 * num_parts) + 1024))
    log_message DEBUG "GRUBPARST_BS_CALC <$GRUBPARST_BS_CALC>"
    ESP=$(parted -m $ROOT print | awk -F ":" '$7 ~ /esp/ { print $1 }')
    log_message DEBUG "ESP <$ESP>"
    if [ $ESP -lt 1 ]; then
        log_message ERROR "ESP partition not found"
        exit 1
    else
        PART_LETTER=""
        if [[ $ROOT =~ nvme ]] || [[ $ROOT =~ mmc ]]; then
            PART_LETTER="p"
        fi
        ESP_PART="$ROOT$PART_LETTER$ESP"
        log_message DEBUG "ESP partition <$ESP_PART>"
        if [ -e "$ESP_PART" ]; then
            run_command "fstrim /boot/efi" "Error calculating ESP partition"
            log_message INFO "Backup ESP partition"
            run_command "zstd --force -T$THREADS -o $BACKUP_DIR/$FILE_PREFIX-$CURDATE.espdd.zst $ESP_PART" "Backup of ESP partition failed"
        else
            log_message INFO "ESP partition <$ESP_PART> not found"
        fi
    fi
else
    GRUBPARST_BS_CALC=512
fi

# save partition table and mbr
log_message INFO "Save mbr"
run_command "dd if=$ROOT of=$BACKUP_DIR/$FILE_PREFIX-$CURDATE.grub bs=446 count=1" "Save of MBR failed"
log_message INFO "Save mbr and partition table"
run_command "dd if=$ROOT of=$BACKUP_DIR/$FILE_PREFIX-$CURDATE.grubparts bs=$GRUBPARST_BS_CALC count=1" "Save of MBR and partition table failed"
# Save partition table using sfdisk
log_message INFO "Save partitions using sfdisk"
run_command "sfdisk --dump $ROOT" "Save of sfdisk partition table failed" "$BACKUP_DIR/$FILE_PREFIX-$CURDATE.sfdisk"

# check for /boot partition
log_message INFO "Check for /boot partition"
BOOT_PART=$(awk '$2 == "/boot" { print $1 }' /proc/mounts)
if [ ! -b "$BOOT_PART" ]; then
    BOOT_PART=""
else
    log_message DEBUG "Boot drive: $BOOT_PART"
fi

# backup u-boot if platform_install.sh exists
#if [ -f "/usr/lib/u-boot/platform_install.sh" ]; then
#  . /usr/lib/u-boot/platform_install.sh
#  if [ -d "${DIR}" ]; then
#    _log "Backup u-boot"
#    tar --create --zstd --file "${backupDir}/${OMV_BACKUP_FILE_PREFIX}-${date}_u-boot.tar.zst" ${DIR}/*
#    if [ $? -eq 0 ]; then
#      _log "Successfully backuped u-boot"
#    else
#      _log_warning "Backup of u-boot failed!"
#    fi
#  fi
#fi

# perform root backup 
log_message INFO "Starting FSArchiver backup"
run_command "fsarchiver savefs -o $BACKUP_DIR/$FILE_PREFIX-$CURDATE.fsa $BOOT_PART $DEVICE_FILE -A -Z3 -j$THREADS" "FSArchiver backup failed"
run_command "fsarchiver archinfo $BACKUP_DIR/$FILE_PREFIX-$CURDATE.fsa" "FSArchiver backup failed"

log_message INFO "*ROOT* backup finished"

# backup root subvolumes
if [ $(blkid -o value -s TYPE $DEVICE_FILE) = "btrfs" ]; then
    IS_BTRFS=yes
else
    IS_BTRFS=no
fi
if [ $IS_BTRFS = yes ]; then
    log_message INFO "*SUBVOLUMES* backup starting"
    # mount / device file
    run_command "mkdir -p $MOUNT_DIR" "Mount root drive failed"
    run_command "mount $DEVICE_FILE $MOUNT_DIR" "Mount root drive failed" 

    SUBVOLUME_LIST=$(btrfs subvolume list $MOUNT_DIR | while read id idval gen genval top level levelval path PATHVAL; do echo -n $PATHVAL ""; done)
    log_message DEBUG "Subvolume list <$SUBVOLUME_LIST>"
    SUBVOLUME_INC_LIST=$(for SUBVOL in $SUBVOLUME_LIST; do 
                            if ! [[ $SUBVOL == *snapshot* || $EXCL_SUBVOLUMES =~ (^|[[:space:]])$SUBVOL($|[[:space:]]) ]]; then
                                echo -n $SUBVOL "";
                            fi;
                        done)
    log_message DEBUG "Subvolumes to backup <$SUBVOLUME_INC_LIST>"                       
    SUBVOLUME_EXC_LIST=$(for SUBVOL in $SUBVOLUME_LIST; do 
                            if [[ $SUBVOL == *snapshot* || $EXCL_SUBVOLUMES =~ (^|[[:space:]])$SUBVOL($|[[:space:]]) ]]; then
                                echo -n $SUBVOL "";
                            fi;
                        done)
    log_message DEBUG "Excluded subvolumes <$SUBVOLUME_EXC_LIST>"                        
    SUBVOLUME_FOLDER_LIST=$(for SUBVOL in $SUBVOLUME_INC_LIST; do 
                                echo -n $MOUNT_DIR/$SUBVOL ""; 
                            done)
    log_message DEBUG "Subvolumes folders <$SUBVOLUME_FOLDER_LIST>"                              

    # saving subvolume info
    for SUBVOL in $SUBVOLUME_LIST; do 
        if [[ $SUBVOL == @ ]]; then
            run_command "echo -n [***] ''" "Error saving subvolume info" "$BACKUP_DIR/$FILE_PREFIX-$CURDATE.subvol.list"
        elif [[ $SUBVOLUME_INC_LIST == *$SUBVOL* ]]; then
            run_command "echo -n [+++] ''" "Error saving subvolume info" "$BACKUP_DIR/$FILE_PREFIX-$CURDATE.subvol.list"
        elif [[ $SUBVOLUME_EXC_LIST == *$SUBVOL* ]]; then
            run_command "echo -n [---] ''" "Error saving subvolume info" "$BACKUP_DIR/$FILE_PREFIX-$CURDATE.subvol.list"
        fi
        run_command "echo $SUBVOL" "Error saving subvolume info" "$BACKUP_DIR/$FILE_PREFIX-$CURDATE.subvol.list"
    done

    # fsarchiver subvolume backup
    log_message INFO "Starting FSArchiver subvolume backup" 
    for SUBVOL in $SUBVOLUME_FOLDER_LIST; do
        TMPNAME=${SUBVOL/$MOUNT_DIR\//}
        TMPNAME=${TMPNAME//\//-}
        TMPNAME=${TMPNAME//@/}
        run_command "fsarchiver savedir -o $BACKUP_DIR/$FILE_PREFIX-$CURDATE.subvol-$TMPNAME.fsa $SUBVOL -A -Z3 -j$THREADS" "Error fsarchiver subvolume backup"
    done
    # cleaning after backup
    run_command "umount $MOUNT_DIR" "Umount root drive failed"
    run_command "rmdir $MOUNT_DIR" "Umount root drive failed"
    log_message INFO "*SUBVOLUMES* backup finished"
fi

# backup extra folders
if [ -n "$FOLDER_LIST" ]; then
    log_message INFO "*FOLDER* backup starting" 
    log_message DEBUG "Folders list <$FOLDER_LIST>"  
    # saving subvolume info
    for FOLDER in $FOLDER_LIST; do 
        run_command "echo [+++] $FOLDER" "Error saving folder info" "$BACKUP_DIR/$FILE_PREFIX-$CURDATE.folder.list"
        TMPNAME=${FOLDER//\//-}
        TMPNAME=${TMPNAME//@/}
        TMPNAME=${TMPNAME:1}
        run_command "fsarchiver savedir -o $BACKUP_DIR/$FILE_PREFIX-$CURDATE.folder-$TMPNAME.fsa $FOLDER -A -Z3 -j$THREADS" "Error fsarchiver folder backup"
    done  

  log_message INFO "*FOLDER* backup finished" 
fi      

# Purging old backups
log_message INFO "Purging old backups"
run_command "touch $BACKUP_DIR/$FILE_PREFIX-$CURDATE.*" "Error updateing backup date-time"
purge_old

log_message INFO "*FULL* backup complete"
exit 0
