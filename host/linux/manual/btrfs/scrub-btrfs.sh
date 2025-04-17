#!/bin/sh

LOG_LEVEL=3
DRY_RUN=no
LOG_NAME="/var/log/scrub-btrfs.log"
#LOG_NAME="./scrub-btrfs.log"

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

log_message INFO "Performing a scrub on all mounted Btrfs file systems"

# Checking sudo permissions
if [ $(id -u) -ne 0 ]; then
  log_message ERROR "Must run as root"
  if [ $IGNORE_ERRORS != yes ]; then
    exit 1
  fi
fi
log_message DEBUG "Running as root"

# Deduplicate UUID to prevent unnecessary work.
log_message DEBUG "\n$(findmnt --list --all --canonicalize --notruncate --nofsroot --uniq --noheadings --output TARGET,UUID --types btrfs | awk '!a[$NF]++')"
findmnt --list --all --canonicalize --notruncate --nofsroot --uniq --noheadings --output TARGET,UUID --types btrfs |
    awk '!a[$NF]++' |
    while read -r TARGET UUID 
do
    log_message INFO "Scrubbing the file system mounted at $TARGET (UUID=$UUID) ..."

    SCRUB_RUNNING=$(btrfs scrub status $TARGET | grep --ignore-case --quiet --perl-regexp 'status:\s+running')
    if [ ! -z "$SCRUB_RUNNING" ]; then
        log_message INFO "Abort, $TARGET is already being processed"
        break
    fi

    SCRUB_ARGS="-c 2 -n 4"
    if [ $DRY_RUN = yes ]; then
        SCRUB_ARGS="$SCRUB_ARGS -r"
    fi

    log_message DEBUG "> btrfs scrub start -B -d $SCRUB_ARGS $TARGET | tail -n +2"
    if [ $DRY_RUN = no ]; then
        STATS=$(btrfs scrub start -B -d $SCRUB_ARGS $TARGET | tail -n +2)
        if [ $? -ne 0 ]; then
            log_message ERROR "Error btrfs scrubbing"
            if [ $IGNORE_ERRORS != yes ]; then
                exit 1
            fi
        fi
    fi

    log_message INFO "Scrubbing the Btrfs file system mounted at $TARGET (UUID=$UUID) has been finished"
    log_message INFO "\n$STATS"
done
