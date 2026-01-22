
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
    echo $NEW_LINE "   $(date +'%Y-%m-%d %H:%M:%S')	$1	: $2" | tee -a $LOG_NAME
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