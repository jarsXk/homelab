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
APITOKEN=$(cat ./cluster-health-token)
DNSCREDENTIALS=$(cat ./cluster-health-dns-credentials)

MAX_LINES=$(tput lines)
MAX_LINES=$(($MAX_LINES - 2))
MAX_COLS=$(tput cols)

if [ "$DEBUG" = "yes" ]; then
  MAX_LINES=15
  MAX_COLS=72

  echo $(tput cols)x$(tput lines)
  echo '+ , - . 0 ` a f g h i j k l m n o p q r s t u v w y x z { | } ~'
  tput smacs
  echo '+ , - . 0 ` a f g h i j k l m n o p q r s t u v w y x z { | } ~'
  tput rmacs
fi

LEFT_COLS=$((MAX_COLS / 2 - 3))
if [ $((MAX_COLS % 2)) -eq 1 ]; then
    LEFT_COLS=$((LEFT_COLS + 1))
fi
RIGHT_COLS=$((MAX_COLS / 2 - 2))

SERVICES_NUM=2
SERVICES_OFFSET=$((MAX_LINES - SERVICES_NUM))

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
    local CLUSTER_HEALTH=$HEALTH_BAD
    local CLUSTER_CORES=0
    local CLUSTER_RAM=0
    local CLUSTER_RAMUSED=0
    CLUSTER_NODES=0
    local CLUSTER_NODESONLINE=0
    if [ ${#CLUSTER_JSON} -ne 0 ]; then
      local CLUSTER_QUORATE="$(echo $CLUSTER_JSON | jq '.data.[] | select(.type == "cluster")' | jq '.quorate')"
      CLUSTER_NODES="$(echo $CLUSTER_JSON | jq '.data.[] | select(.type == "cluster")' | jq '.nodes')"
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
          CLUSTER_HEALTH=$HEALTH_GOOD
        elif [ $CLUSTER_NODESONLINE -ge $CLUSTER_QUORUM ]; then
          CLUSTER_HEALTH=$HEALTH_WARN
        fi
      else
        CLUSTER_HEALTH=$HEALTH_BAD
      fi  
    fi
    tput smacs
    echo -en "$CLUSTER_HEALTH"
    tput rmacs
    echo -n " nodes"
    fill " " "$(($2 - 31))"
    echo -n "$RESSTR"
    echo -n "(N ${CLUSTER_NODESONLINE}/${CLUSTER_NODES} C ${CLUSTER_CORES} Mem ${CLUSTER_RAMUSED}/${CLUSTER_RAM}G)"
  elif [ $1 -eq 3 ]; then

    # Line 3 (ceph health)
    local CEPH_HEALTH=$HEALTH_BAD
    local CEPH_MONS=0
    local CEPH_OSD=0
    local CEPH_OSDONLINE=0
    if [ ${#CEPH_JSON} -ne 0 ]; then
      local TMPVAL="$(echo $CEPH_JSON | jq '.data.health.status')"
      local TMPVAL=${TMPVAL#\"}
      local TMPVAL=${TMPVAL%\"}
      if [ "$TMPVAL" = "HEALTH_OK" ]; then
        CEPH_HEALTH=$HEALTH_GOOD
      else
        CEPH_HEALTH=$HEALTH_BAD
      fi
      local TMPVAL="$(echo $CEPH_JSON | jq '.data.monmap.mons | length')"
      substr "$TMPVAL" 1 yes
      local CEPH_MONS=$RESSTR

      TMPVAL="$(echo $CEPH_JSON | jq '.data.osdmap.num_osds')"
      substr "$TMPVAL" 1 yes
      local CEPH_OSD=$RESSTR
      local TMPVAL="$(echo $CEPH_JSON | jq '.data.osdmap.num_up_osds')"
      substr "$TMPVAL" 1 yes
      local CEPH_OSDONLINE=$RESSTR
    fi
    tput smacs
    echo -en $CEPH_HEALTH
    tput rmacs
    echo -n " ceph"
    fill " " "$(($2 - 27))"
    echo -n "$RESSTR"
    echo -n "(Mon ${CEPH_MONS}/${CEPH_MONS} OSD  ${CEPH_OSD}/${CEPH_OSDONLINE}  )"

  elif [ $1 -eq 4 ]; then
    # Line 4 empty
    fill " " "$LEFT_COLS"
    echo -n "$RESSTR"

  elif [ $1 -eq 5 ]; then  
    # Line 4 (nodes header)
    tput smacs
    echo -n "q"
    tput rmacs
    echo -n " Nodes "
    tput smacs
    fill "q" "$(($2 - 8))"
    echo -n "$RESSTR"
    tput rmacs      
    
  elif [ $1 -ge 6 ]; then            
    # Line N (hosts)
    local CUR_ENTRY=$(( $1 - 6 ))
    if [ $CUR_ENTRY -lt $CLUSTER_NODES ]; then
      local NODE_HEALTH=$HEALTH_BAD
      local NODE_JSON="$(echo $RESOURCES_JSON | jq '[ .data[] | select(.type == "node") ]' | jq '.['$CUR_ENTRY']')"      
      local TMPVAL="$(echo $NODE_JSON | jq '.status')"
      local TMPVAL=${TMPVAL#\"}
      local TMPVAL=${TMPVAL%\"}
      if [ "$TMPVAL" = "online" ]; then
        local NODE_HEALTH=$HEALTH_GOOD
      else
        local NODE_HEALTH=$HEALTH_BAD
      fi

      local TMPVAL="$(echo $NODE_JSON | jq '.node')"
      local TMPVAL=${TMPVAL#\"}
      local TMPVAL=${TMPVAL%\"}
      substr "$TMPVAL" 12
      local NODE_NAME=$RESSTR

      local TMPVAL="$(echo $NODE_JSON | jq '.cpu')"
      if (( $(echo "$TMPVAL < 0.01" | bc -l) )); then
        local TMPVAL=$(echo "scale=1; $TMPVAL * 100 / 1" | bc)
      else
        local TMPVAL=$(echo "scale=0; $TMPVAL * 100 / 1" | bc)
      fi
      substr "$TMPVAL" 3 yes
      local NODE_CPU=$RESSTR

      local TMPVAL="$(echo $NODE_JSON | jq '.maxmem')"
      local TMPVAL=$(($TMPVAL / 1000000000))
      substr "$TMPVAL" 2 yes
      local NODE_RAM=$RESSTR
      local TMPVAL="$(echo $NODE_JSON | jq '.mem')"

      if (( $(echo "$TMPVAL < 1000000000" | bc -l) )); then
        local TMPVAL=$(echo "scale=1; $TMPVAL / 1000000000" | bc)
      else
        local TMPVAL=$(($TMPVAL / 1000000000))
      fi
      substr "$TMPVAL" 2 yes
      local NODE_RAMUSED=$RESSTR
      
      tput smacs
      echo -en $NODE_HEALTH" "
      tput rmacs
      echo -n "$NODE_NAME (L ${NODE_CPU}% M ${NODE_RAMUSED}/${NODE_RAM}G)"
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

  elif [ $1 -ge 2 ] && [ $1 -lt $SERVICES_OFFSET ]; then
    # Line M (guest)
    local CUR_ENTRY=$(( $1 - 2 ))
    local CLUSTER_GUESTS="$(echo $GUESTS_JSON | jq '. | length')"
    if [ $CUR_ENTRY -lt $CLUSTER_GUESTS ]; then

      local GUEST_HEALTH=$HEALTH_UNKNOWN
      local GUEST_JSON="$(echo $GUESTS_JSON | jq '. | sort_by(.vmid)' | jq '.['$CUR_ENTRY']')"      

      local TMPVAL="$(echo $GUEST_JSON | jq '.status')"
      local TMPVAL=${TMPVAL#\"}
      local TMPVAL=${TMPVAL%\"}
      if [ "$TMPVAL" = "running" ]; then
        local GUEST_HEALTH=$HEALTH_GOOD
      elif [ "$TMPVAL" = "stopped" ]; then
        local GUEST_HEALTH=$HEALTH_UNKNOWN
      else
        local GUEST_HEALTH=$HEALTH_BAD
      fi
      
      local TMPVAL="$(echo $GUEST_JSON | jq '.name')"
      local TMPVAL=${TMPVAL#\"}
      local TMPVAL=${TMPVAL%\"}
      substr "$TMPVAL" 13
      local GUEST_NAME=$RESSTR

      local TMPVAL="$(echo $GUEST_JSON | jq '.cpu')"
      local TMPVAL=$(echo "scale=0; $TMPVAL * 100 / 1" | bc)
      substr "$TMPVAL" 3 yes
      local GUEST_CPU=$RESSTR

      local TMPVAL="$(echo $GUEST_JSON | jq '.maxmem')"
      if (( $(echo "$TMPVAL < 1000000000" | bc -l) )); then
        local TMPVAL=$(echo "scale=1; $TMPVAL / 1000000000" | bc)
      else
        local TMPVAL=$(($TMPVAL / 1000000000))
      fi
      substr "$TMPVAL" 2 yes
      local GUEST_RAM=$RESSTR
      local TMPVAL="$(echo $GUEST_JSON | jq '.mem')"
      if (( $(echo "$TMPVAL < 1000000000" | bc -l) )); then
        local TMPVAL=$(echo "scale=1; $TMPVAL / 1000000000" | bc)
      else
        local TMPVAL=$(($TMPVAL / 1000000000))
      fi
      substr "$TMPVAL" 2 yes
      local GUEST_RAMUSED=$RESSTR

      tput smacs
      echo -en "$GUEST_HEALTH "
      tput rmacs
      echo -n "$GUEST_NAME (L ${GUEST_CPU}% M ${GUEST_RAMUSED}/${GUEST_RAM}G)"
    else
      fill " " "$RIGHT_COLS"
      echo -n "$RESSTR"
    fi
    
  elif [ $1 -eq $SERVICES_OFFSET ]; then
    # Line Services (services header) 
    tput smacs
    echo -n "q"
    tput rmacs
    echo -n " Services "
    tput smacs
    fill "q" "$(($2 - 11))"
    echo -n "$RESSTR"
    tput rmacs
    
  elif [ $1 -eq $((SERVICES_OFFSET + 1)) ]; then
    # Line Services + 1 (dns)
    local DNS_HEALTH=$HEALTH_UNKNOWN
    local TMPVAL="$(curl -ks -u "$DNSCREDENTIALS" https://moondns.lan/control/status | jq '.running')"
    if [ "$TMPVAL" = "true" ]; then
      local DNS_HEALTH=$HEALTH_GOOD
    else
      local DNS_HEALTH=$HEALTH_BAD
    fi
    tput smacs
    echo -en "$DNS_HEALTH "
    tput rmacs
    substr "dns" $(( $RIGHT_COLS - 3 ))
    echo -n "$RESSTR"

  elif [ $1 -eq $((SERVICES_OFFSET + 2)) ]; then
    # Line Services + 1 (dns)
    local PROXY_HEALTH=$HEALTH_UNKNOWN
    local TMPVAL="$(curl -s http://moonproxy.lan:30320/api/ | jq '.status')"
    local TMPVAL=${TMPVAL#\"}
    local TMPVAL=${TMPVAL%\"}
    if [ "$TMPVAL" = "OK" ]; then
      local PROXY_HEALTH=$HEALTH_GOOD
    else
      local PROXY_HEALTH=$HEALTH_BAD
    fi
    tput smacs
    echo -en "$PROXY_HEALTH "
    tput rmacs
    substr "proxy" $(( $RIGHT_COLS - 3 ))
    echo -n "$RESSTR"
  fi
} 

get "/cluster/status"
CLUSTER_JSON=$RESSTR
get "/cluster/ceph/status"
CEPH_JSON=$RESSTR
get "/cluster/resources"
RESOURCES_JSON=$RESSTR
GUESTS_JSON="$(echo $RESOURCES_JSON | jq '[ .data[] | select(.type == "qemu") | select(.template == 0) ]')"

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

# Line End (footer)
tput smacs
echo -n 'm'
fill "q" "$((MAX_COLS - 2))"
echo -n "$RESSTR"
#echo 'j'
tput rmacs
