#!/bin/bash

COLOR_RED="\e[31m"
COLOR_GREEN="\e[32m"
COLOR_YELLOW="\e[33m"
COLOR_WHITE="\e[37m"
COLOR_RESET="\e[0m"

HEALTH_GOOD="${COLOR_GREEN}00${COLOR_RESET}"
HEALTH_WARN="${COLOR_YELLOW}00${COLOR_RESET}"
HEALTH_BAD="${COLOR_RED}00${COLOR_RESET}"
HEALTH_UNKNOWN="${COLOR_WHITE}00${COLOR_RESET}"

MAX_LINES=$(tput lines)
MAX_LINES=$(($MAX_LINES - 2))
MAX_COLS=$(tput cols)

if [ "$DEBUG" = "yes" ]; then
  MAX_LINES=17
  MAX_COLS=72
fi

TERRA_LINES=3
MOON_LINES=$((MAX_LINES - TERRA_LINES))

LEFT_COLS=$((MAX_COLS / 2 - 3))
if [ $((MAX_COLS % 2)) -eq 1 ]; then
    LEFT_COLS=$((LEFT_COLS + 1))
fi
RIGHT_COLS=$((MAX_COLS / 2 - 2))

# substr строка длина добавлять_в_начало
substr() {
  local INSTRING="$1"
  local INMAXLENGTH="$2"
  local INLEFT="$3"
  RESSTR=""

  # ensure LENGTH is integer >= 0
  if ! [[ "$INMAXLENGTH" =~ ^[0-9]+$ ]]; then
    echo "Invalid length" >&2
    return 1
  fi

  local STRINGLENGTH=${#INSTRING}
  if (( STRINGLENGTH == INMAXLENGTH )); then
    RESSTR="$INSTRING"
  elif (( STRINGLENGTH > INMAXLENGTH )); then
    RESSTR="${INSTRING:0:INMAXLENGTH}"
  else
    local SPACES=$(printf '%*s' $((INMAXLENGTH - STRINGLENGTH)) '')
    if [ "$#" = "2" ]; then
      RESSTR="${INSTRING}${SPACES}"
    else 
      RESSTR="${SPACES}${INSTRING}"
    fi
    
  fi
}

# substr символ длина
fill() {
  local INSYMBOL="$1"
  local INLENGTH="$2"
  RESSTR=""

  # ensure LENGTH is integer >= 0
  if ! [[ "$INLENGTH" =~ ^[0-9]+$ ]]; then
    echo "Invalid length" >&2
    return 1
  fi

  INSYMBOL=${INSYMBOL:0:1}

  RESSTR=""
  for ((j=0;j<INLENGTH;j++)); do 
    RESSTR=$RESSTR$INSYMBOL;
  done
}

while [ true ]; do
  clear

  if [ "$DEBUG" = "yes" ]; then
    echo $(tput cols)x$(tput lines)
    echo '+ , - . 0 ` a f g h i j k l m n o p q r s t u v w y x z { | } ~'
    tput smacs
    echo '+ , - . 0 ` a f g h i j k l m n o p q r s t u v w y x z { | } ~'
    tput rmacs
  fi
  
  . /home/monitor/server-health/terra-refresh.sh
  . /home/monitor/server-health/moon-refresh.sh

  sleep 2m
done
