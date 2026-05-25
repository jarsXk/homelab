#!/bin/bash

APP_LABEL=(D Px Vw Ca Jf)
APP_STATUS=(? ? ? ? ?)
APP_LENGTH=${#APP_LABEL[@]}

APPS_LINES=2

DNSCREDENTIALS=$(cat /home/monitor/server-health/moondns-credentials)

# Fill data
I=0
for LABEL in "${APP_LABEL[@]}"; do
  # DNS
  if [ "$LABEL" = "D" ]; then
    if [ $(dig mani.lan @moondns.lan | grep 172.20.2.20 | wc -c) -gt 0 ]; then
      APP_STATUS[$I]=Y
    else
      APP_STATUS[$I]=N
    fi
  # Proxy
  elif [ "$LABEL" = "Px" ]; then
    TMPVAL="$(curl -s http://moonproxy.lan:30320/api/ | jq '.status')"
    TMPVAL=${TMPVAL#\"}
    TMPVAL=${TMPVAL%\"}
    if [ "$TMPVAL" = "OK" ]; then
      APP_STATUS[$I]=Y
    else
      APP_STATUS[$I]=N
    fi
  # VaultWarden
  elif [ "$LABEL" = "Vw" ]; then
    if [ "$(curl -si http://moondocs.lan:31720/api/version | wc -c)" -gt 0 ]; then
      APP_STATUS[$I]=Y
    else
      APP_STATUS[$I]=N
    fi
  # CalibreWeb
  elif [ "$LABEL" = "Ca" ]; then
    if [ "$(curl -si http://moonmedia.lan:31220 | grep Location: | wc -c)" -gt 0 ]; then
      APP_STATUS[$I]=Y
    else
      APP_STATUS[$I]=N
    fi
  # Jellyfin
  elif [ "$LABEL" = "Jf" ]; then
    TMPVAL="$(curl -s http://moonmedia.lan:31020/System/Ping)"
    TMPVAL=${TMPVAL#\"}
    TMPVAL=${TMPVAL%\"}
    if [ "$TMPVAL" = "Jellyfin Server" ]; then
      APP_STATUS[$I]=Y
    else
      APP_STATUS[$I]=N
    fi
  fi
  I=$((I + 1))
done

# Line 1 (header)
tput smacs
echo -n "lqqqqq"
tput rmacs
echo -en " Applications "
tput smacs
fill "q" "$((MAX_COLS - 21))"
echo -n "$RESSTR"
echo 'k'
tput rmacs

# Line 2 (statuses)
tput smacs
echo -n 'x '
for STATUS in "${APP_STATUS[@]}"; do
  if [ "$STATUS" = "Y" ]; then
    echo -en "$HEALTH_GOOD "
  elif [ "$STATUS" = "N" ]; then
    echo -en "$HEALTH_BAD "
  else
    echo -en "$HEALTH_UNKNOWN "
  fi
done
substr "" "$((MAX_COLS - (APP_LENGTH * 3) - 4))"
echo "$RESSTR x"
tput rmacs

# Line 3 (labels)
tput smacs
echo -n 'x '
tput rmacs
for LABEL in "${APP_LABEL[@]}"; do
  substr "$LABEL" 3
  echo -n "$RESSTR"
done
tput smacs
substr "" "$((MAX_COLS - (APP_LENGTH * 3) - 4))"
echo "$RESSTR x"
tput rmacs

# Line End (footer)
tput smacs
echo -n 'm'
fill "q" "$((MAX_COLS - 2))"
echo -n "$RESSTR"
#echo 'j'
tput rmacs