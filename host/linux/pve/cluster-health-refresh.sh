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

SERVER_LIST=("luna.lan" "selena.lan")
APITOKEN="monitor@pam!view=40bc90f1-837c-4731-b068-c2b7589a7384"

MAX_LINES=10
#MAX_COLS=$(tput cols)
MAX_COLS=72
LEFT_COLS=$((MAX_COLS / 2 - 2))
RIGHT_COLS=$((MAX_COLS / 2 - 3))
if [ $((MAX_COLS % 2)) -eq 1 ]; then
    RIGHT_COLS=$((RIGHT_COLS + 1))
fi

RESSTR=""

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

get() {
  local ENDPOINT="$1"
  local SERVER=""
  RESSTR=""

  for i in "${SERVER_LIST[@]}"; do
    if ping -c 1 $i &> /dev/null; then 
      SERVER="$i"
      break
    fi
  done
  
  RESSTR=$(curl -ksH "Authorization: PVEAPIToken=$APITOKEN" https://$SERVER:8006/api2/json$ENDPOINT)
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
    TMP_HEALTH=$HEALTH_BAD
    local CLUSTER_CORES=0
    local CLUSTER_RAM=0
    local CLUSTER_RAMUSED=0
    local CLUSTER_NODES=0
    local CLUSTER_NODESONLINE=0
    if [ ${#CLUSTER_JSON} -ne 0 ]; then
      local CLUSTER_QUORATE="$(echo $CLUSTER_JSON | jq '.data.[] | select(.type == "cluster")' | jq '.quorate')"
      local CLUSTER_NODES="$(echo $CLUSTER_JSON | jq '.data.[] | select(.type == "cluster")' | jq '.nodes')"
      local CLUSTER_QUORUM=$(($CLUSTER_NODES / 2 + 1))
      local CLUSTER_NODESONLINE="$(echo $CLUSTER_JSON | jq '[ .data.[] | select(.type == "node") | select (.online == 1) ] | length')"
     
      local TMPVAL="$(echo $RESOURCES_JSON | jq '[ .data[] | select(.type == "node") | .maxcpu ] | add ')"
      substr "$TMPVAL" 2 yes
      local CLUSTER_CORES=$RESSTR
     
      local TMPVAL="$(echo $RESOURCES_JSON | jq '[ .data[] | select(.type == "node") | .maxmem ] | add ')"
      local TMPVAL=$(($TMPVAL / 1000000000))
      substr "$TMPVAL" 2 yes
      local CLUSTER_RAM=$RESSTR
      local TMPVAL="$(echo $RESOURCES_JSON | jq '[ .data[] | select(.type == "node") | .mem ] | add ')"
      local TMPVAL=$(($TMPVAL / 1000000000))
      substr "$TMPVAL" 2 yes
      local CLUSTER_RAMUSED=$RESSTR

      if [ "$CLUSTER_QUORATE" -eq "1" ]; then
        if [ $CLUSTER_NODESONLINE -eq $CLUSTER_NODES ]; then
          TMP_HEALTH=$HEALTH_GOOD
        elif [ $CLUSTER_NODESONLINE -ge $CLUSTER_QUORUM ]; then
          TMP_HEALTH=$HEALTH_WARN
        fi
      else
        TMP_HEALTH=$HEALTH_BAD
      fi  
    fi
    tput smacs
    echo -en "$TMP_HEALTH"
    tput rmacs
    echo -n " nodes"
    fill " " "$(($2 - 31))"
    echo -n "$RESSTR"
    echo -n "(N ${CLUSTER_NODESONLINE}/${CLUSTER_NODES} C ${CLUSTER_CORES} Mem ${CLUSTER_RAMUSED}/${CLUSTER_RAM}G)"
  elif [ $1 -eq 3 ]; then

    # Line 3 (ceph health)
    TMP_HEALTH=$HEALTH_BAD
    local CEPH_MONS=0
    local CEPH_OSD=0
    local CEPH_OSDONLINE=0
    if [ ${#CEPH_JSON} -ne 0 ]; then
      TMPVAL="$(echo $CEPH_JSON | jq '.data.health.status')"
      TMPVAL=${TMPVAL#\"}
      TMPVAL=${TMPVAL%\"}
      if [ "$TMPVAL" = "HEALTH_OK" ]; then
        TMP_HEALTH=$HEALTH_GOOD
      else
        TMP_HEALTH=$HEALTH_BAD
      fi
      TMPVAL="$(echo $CEPH_JSON | jq '.data.monmap.mons | length')"
      substr "$TMPVAL" 1 yes
      local CEPH_MONS=$RESSTR

      TMPVAL="$(echo $CEPH_JSON | jq '.data.osdmap.num_osds')"
      substr "$TMPVAL" 1 yes
      local CEPH_OSD=$RESSTR
      TMPVAL="$(echo $CEPH_JSON | jq '.data.osdmap.num_up_osds')"
      substr "$TMPVAL" 1 yes
      local CEPH_OSDONLINE=$RESSTR
    fi
    tput smacs
    echo -en $TMP_HEALTH
    tput rmacs
    echo -n " ceph"
    fill " " "$(($2 - 27))"
    echo -n "$RESSTR"
    echo -n "(Mon ${CEPH_MONS}/${CEPH_MONS} OSD  ${CEPH_OSD}/${CEPH_OSDONLINE}  )"
  elif [ $1 -eq 5 ]; then
  
    # Line 4 (servers header)
    tput smacs
    echo -n "q"
    tput rmacs
    echo -n " Nodes "
    tput smacs
    fill "q" "$(($2 - 8))"
    echo -n "$RESSTR"
    tput rmacs
  elif [ $1 -eq 4 ] || [ $1 -ge 6 ]; then
    # Line N (hosts)
    if [ $1 -eq 6 ]; then
      HOSTNAME="luna"
    elif [ $1 -eq 7 ]; then
      HOSTNAME="selena"
    # elif [ $1 -eq 7 ]; then
    #   HOSTNAME="hina"  
    # elif [ $1 -eq 8 ]; then
    #   HOSTNAME="chandra"
    else
      HOSTNAME="null"
    fi
    if [ "$HOSTNAME" != "null" ]; then
      tput smacs
      echo -en $HEALTH_UNKNOWN" "
      tput rmacs
      substr "$HOSTNAME" 9
      echo -n "$RESSTR (L   0/100% M  0/ 0G)"
    else
      fill " " "$LEFT_COLS"
      echo -n "$RESSTR"
    fi
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
    substr "guest$1" 8
    echo -n "$RESSTR (L   0/100% M  0/ 0G)"
  fi
} 


echo $(tput cols)x$(tput lines)

get "/cluster/status"
CLUSTER_JSON=$RESSTR
get "/cluster/ceph/status"
CEPH_JSON=$RESSTR
get "/cluster/resources"
RESOURCES_JSON=$RESSTR

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
