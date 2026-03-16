#!/bin/bash

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_RESET='\033[0m'

HEALTH_GOOD='\U1F7E2'
HEALTH_WARN='\U1F7E1'
HEALTH_BAD='\U1F534'
HEALTH_UNKNOWN='\U26AA'
MOON='\U1F319'

GUEST_LINES=10

MAX_LINES=10
MAX_COLS=80
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

  RESSTR=$(curl -ksH 'Authorization: PVEAPIToken=monitor@pam!view=40bc90f1-837c-4731-b068-c2b7589a7384' https://172.20.2.20:8006/api2/json$ENDPOINT)
}

left_row ()  {
  if [ $1 -eq 1 ]; then
    # Line 1 (cluster header)
    tput smacs
    echo -n 'q'
    tput rmacs
    echo -n ' Cluster '
    tput smacs
    fill "q" "$((LEFT_COLS - 10))"
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
    echo -en $TMP_HEALTH
    tput rmacs
    echo -n ' quorum (Srv: 0/4 Mem:  0/ 0GB)     '
  elif [ $1 -eq 3 ]; then
    # Line 3 (ceph health)
    tput smacs
    echo -en $HEALTH_UNKNOWN
    tput rmacs
    echo -n ' ceph (Mon: 0/4 OSD: 0/2)           '
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
    echo -n "$RESSTR (CPU:  0/100% Mem:  0/ 0GB)"
  else
    fill " " "$LEFT_COLS"
    echo -n "$RESSTR"
  fi
} 

right_row ()  {
  if [ $1 -eq 1 ]; then
    # Line 1 (guests header) 
    tput smacs
    echo -n 'q '
    tput rmacs
    echo -n 'Guests'
    tput smacs
    echo -n ' qqqqqqqqqqqqqqqqqqqqqqqqqqqq'
    tput rmacs
  else
    echo -n 'guest'$1
    if [ $1 -lt 10 ]; then
      echo -n ' '
    fi 
    tput smacs
    echo -en ' '$HEALTH_UNKNOWN
    tput rmacs
    echo -n ' (CPU:  0/100% Mem: 0/0GB) '
  fi
} 


get "/cluster/status"
CLUSTER_JSON=$RESSTR

while [ true ]; do
  clear

  # Line 1 (header)
  tput smacs
  echo -n 'lqqqqq'
  tput rmacs
  echo -en ' '$MOON' Moon '
  tput smacs
  fill "q" "$((MAX_COLS - 16))"
  echo -n "$RESSTR"
  echo 'k'
  tput rmacs

  # Line N (hosts-guests)
  i=1
  until [ $i -gt $MAX_LINES ]; do
    tput smacs
    echo -n 'x '
    tput rmacs 
    left_row $i $MAX_COLS
    echo -n ' '
    right_row $i $MAX_COLS
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


  sleep 30s
done
