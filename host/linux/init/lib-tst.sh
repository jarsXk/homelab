
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
