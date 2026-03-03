
# Reading physical server
while [ "$PHYSICAL" = "" ]; do
  log_message READ "Setup physical server [y/n/c]> " -n
  read -r ANSWER_PHYSICAL
  case "$ANSWER_PHYSICAL" in
    [Yy]* )
      PHYSICAL=yes
    ;;
    [Nn]* )
      PHYSICAL=no
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
log_message DEBUG "Selected install physical server <$PHYSICAL>"

if [ "$SERVER_ROLE" = "" ];
# Reading location
while [ "$SERVER_ROLE" = "" ]; do
  log_message READ "Setup NAS host [y/n/c]> " -n
  read -r ANSWER_NAS
  case "$ANSWER_NAS" in
    [Yy]* )
      SERVER_ROLE="nas"
    ;;
    [Nn]* )
      SERVER_ROLE=""
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

# Reading location
while [ "$LOCATION" = "" ]; do
  log_message READ "Location"
  log_message READ "  [1] null"
  log_message READ "  [2] vasilkovo"
  log_message READ "  [3] chanovo"
  log_message READ "  [5] yasenevof"    
  log_message READ "  [6] shodnenskaya4/5"
  log_message READ "  [0] other"
  log_message READ "Select [1-4/0/c]> " -n
  read -r ANSWER_LOCATION
  case "$ANSWER_LOCATION" in
    1)
      LOCATION=null
    ;;
    2)
      LOCATION=vasilkovo
    ;;
    3)
      LOCATION=chanovo
    ;;
    4)
      LOCATION=yasenevof
    ;;
    5)
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
log_message DEBUG "Selected SERVER_ROLE host <$SERVER_ROLE>"
log_message DEBUG "Selected location <$LOCATION>"