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

GUEST_LINES=5

MAX_LINES=7
MAX_COLS=$(tput cols)
LEFT_COLS=$((MAX_COLS / 2 - 2))
RIGHT_COLS=$((MAX_COLS / 2 - 3))
if [ $((MAX_COLS % 2)) -eq 1 ]; then
    RIGHT_COLS=$((RIGHT_COLS + 1))
fi

RESSTR=""

# substr строка длина
substr() {
  local INSTRING="$1"
  local INMAXLENGTH="$2"

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
    RESSTR="${INSTRING}${SPACES}"
  fi
}

# substr символ длина
fill() {
  local INSYMBOL="$1"
  local INLENGTH="$2"

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

get() {
  local ENDPOINT="$1"

  RESSTR=$(curl -ksH 'Authorization: PVEAPIToken=monitor@pam!view=40bc90f1-837c-4731-b068-c2b7589a7384' https://172.20.2.21:8006/api2/json$ENDPOINT)
}

left_row ()  {
  if [ $1 -eq 1 ]; then
  
    # Line 1 (cluster header)
    tput smacs
    echo -n "q"
    tput rmacs
    echo -n " Cluster "
    tput smacs
    fill "q" "$(($2 - 10))"
    echo -n "$RESSTR"
    tput rmacs
  elif [ $1 -eq 2 ]; then
  
    # Line 2 (cluster health)
    if [ "$(echo $CLUSTER_JSON | jq '.data.[] | select(.type == "cluster")' | jq '.quorate')" -eq "1" ]; then
      TMP_HEALTH=$HEALTH_GOOD
    else
      TMP_HEALTH=$HEALTH_BAD
    fi  
    tput smacs
    echo -en "$TMP_HEALTH"
    tput rmacs
    echo -n " quorum (Srv 0/4 Mem  0/ 0G)"
    fill " " "$(($2 - 30))"
    echo -n "$RESSTR"
  elif [ $1 -eq 3 ]; then
    # Line 3 (ceph health)
    tput smacs
    echo -en $HEALTH_UNKNOWN
    tput rmacs
    echo -n ' ceph (Mon 0/3 OSD 0/2)           '
  elif [ $1 -eq 4 ]; then
    # Line 4 (hosts header)
    tput smacs
    echo -n 'q '
    tput rmacs
    echo -n 'Servers'
    tput smacs
    echo -n ' qqqqqqqqqqqqqqqqqqqqqqqqqqqq'
    tput rmacs
  elif [ $1 -ge 5 ] && [ $1 -le 8 ]; then
    # Line N (hosts)
    if [ $1 -eq 5 ]; then
      HOSTNAME="hina"
    elif [ $1 -eq 6 ]; then
      HOSTNAME="luna"
    elif [ $1 -eq 7 ]; then
      HOSTNAME="selena"
    elif [ $1 -eq 8 ]; then
      HOSTNAME="chandra"
    else
      HOSTNAME="unidentified"
    fi
    tput smacs
    echo -en $HEALTH_UNKNOWN' '
    tput rmacs
    substr "$HOSTNAME" 7
    echo -n "$RESSTR (C:  0/100% M:  0/ 0GB)"
  else
    fill " " "$LEFT_COLS"
    echo -n "$RESSTR"
  fi
} 

right_row ()  {
  if [ $1 -eq 1 ]; then
    # Line 1 (guests header) 
    tput smacs
    echo -n "q"
    tput rmacs
    echo -n " Guests "
    tput smacs
    fill "q" "$(($2 - 9))"
    echo -n "$RESSTR"
    tput rmacs
  else
    tput smacs
    echo -en "$HEALTH_UNKNOWN "
    tput rmacs
    TMP_NAME="guest$1"
    if [ $1 -lt 10 ]; then
      TMP_NAME="$TMP_NAME "
    fi 
    echo -n "$TMP_NAME (C  0/100% M  0/ 0G)  "
    fill " " "$(($2 - 33))"
        echo -n "$RESSTR"
  fi
} 


echo $(tput cols)x$(tput lines)

get "/cluster/status"
CLUSTER_JSON=$RESSTR

# Line 1 (header)
tput smacs
echo -n "lqqqqq"
tput rmacs
echo -en " Moon "
tput smacs
fill "q" "$((MAX_COLS - 13))"
echo -n "$RESSTR"
echo 'k'
tput rmacs

# Line N (hosts-guests)
i=1
until [ $i -gt $MAX_LINES ]; do
  tput smacs
  echo -n 'x '
  tput rmacs 
  left_row $i $LEFT_COLS
  echo -n ' '
  right_row $i $RIGHT_COLS
  tput smacs
  echo -n ' x'
  tput rmacs
  echo ""

  i=$((i+1))
done

# Line End (header)
tput smacs
echo -n 'm'
fill "q" "$((MAX_COLS - 2))"
echo -n "$RESSTR"
echo 'j'
tput rmacs





echo
echo '+ , - . 0 ` a f g h i j k l m n o p q r s t u v w y x z { | } ~'
tput smacs
echo '+ , - . 0 ` a f g h i j k l m n o p q r s t u v w y x z { | } ~'
tput rmacs
