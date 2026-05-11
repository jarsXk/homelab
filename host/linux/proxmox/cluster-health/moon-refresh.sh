#!/bin/bash

SERVER_LIST=("luna.lan" "selena.lan")
APITOKEN=$(cat /home/monitor/server-health/moon-token)

MOON_LINES=$((MAX_LINES - TERRA_LINES - 4))

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

RESSTR=""

left_row ()  {
  # Line 1 (cluster health)
  if [ $1 -eq 1 ]; then  
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

  # Line 2+HOSTS (hosts)
  elif [ $1 -ge 2 ] && [ $1 -lt $((2 + CLUSTER_NODES)) ]; then
    local CUR_ENTRY=$(( $1 - 2 ))
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
      substr "$TMPVAL" 11
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
      echo -n "  $NODE_NAME (L${NODE_CPU}% M ${NODE_RAMUSED}/${NODE_RAM}G)"
    else
      fill " " "$LEFT_COLS"
      echo -n "$RESSTR"
    fi
  
  # Line 2+HOSTS+1 empty
  elif [ $1 -eq $((2 + CLUSTER_NODES)) ]; then
    fill " " "$LEFT_COLS"
    echo -n "$RESSTR"

  # Line 2+HOSTS+2 (ceph health)
  elif [ $1 -eq $((2 + CLUSTER_NODES + 1)) ]; then
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

  # Line 2+HOSTS+CEPH+1 empty
  elif [ $1 -ge $((2 + CLUSTER_NODES + 2)) ]; then
    fill " " "$LEFT_COLS"
    echo -n "$RESSTR"  
     
  fi
}   
  

right_row ()  {
  # Line 1+GUEST (guest)  
  if [ $1 -ge 1 ]; then
    local CUR_ENTRY=$(( $1 - 1 ))
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
      substr "$TMPVAL" 14
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
      echo -n "$GUEST_NAME (L${GUEST_CPU}% M ${GUEST_RAMUSED}/${GUEST_RAM}G)"
    else
      fill " " "$RIGHT_COLS"
      echo -n "$RESSTR"
    fi
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
until [ $i -gt $MOON_LINES ]; do
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
echo 'j'
tput rmacs
