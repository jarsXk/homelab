#!/bin/bash

TERRA_LINES=3
RESSTR=""

left_row ()  {
  if [ $1 -eq 1 ]; then
    # Line 1 (host health)
    local HOST_HEALTH=$HEALTH_BAD
    local HOST_RAM=" 0"
    local HOST_RAMUSED=" 0"
    local HOST_CPU="  0"

    if [ ${#HOST_JSON} -ne 0 ]; then
      local HOST_HEALTH=$HEALTH_GOOD

      local TMPVAL="$(echo $HOST_JSON | jq '.[].cpu_idle')"
      local TMPVAL=$(echo "100 - $TMPVAL" | bc)
      if (( $(echo "$TMPVAL < 1" | bc -l) )); then
        local TMPVAL=$(echo "scale=1; $TMPVAL / 1" | bc)
      else
        local TMPVAL=$(echo "scale=0; $TMPVAL / 1" | bc)
      fi
      substr "$TMPVAL" 3 yes
      local HOST_CPU=$RESSTR

      local TMPVAL="$(echo $HOST_JSON | jq '.[].mem_total')"
      local TMPVAL=$(echo "scale=0; $TMPVAL / 1000" | bc)
      substr "$TMPVAL" 2 yes
      local HOST_RAM=$RESSTR
      local TMPVAL="$(echo $HOST_JSON | jq '.[].mem_used')"
      if (( $(echo "$TMPVAL < 1000" | bc -l) )); then
        local TMPVAL=$(echo "scale=1; $TMPVAL / 1000" | bc)
      else
        local TMPVAL=$(echo "scale=0; $TMPVAL / 1000" | bc)
      fi
      substr "$TMPVAL" 2 yes
      local HOST_RAMUSED=$RESSTR
    fi

    tput smacs
    echo -en "$HOST_HEALTH"
    tput rmacs
    echo -n " host"
    fill " " "$(($2 - 26))"
    echo -n "$RESSTR"
    echo -n "(L ${HOST_CPU}% Mem ${HOST_RAMUSED}/${HOST_RAM}G)"

  else
    fill " " "$LEFT_COLS"
    echo -n "$RESSTR"
  fi

}

right_row ()  {
  fill " " "$RIGHT_COLS"
  echo -n "$RESSTR"
}


HOST_JSON=$(ssh -qt monitor@terra.lan "top -b -n 1 -p 0 > ./top.txt && cat ./top.txt" | jc --top)

# Line 1 (header)
tput smacs
echo -n "lqqqqq"
tput rmacs
echo -en " Terra "
tput smacs
fill "q" "$((MAX_COLS - 14))"
echo -n "$RESSTR"
echo 'k'
tput rmacs

# Line N (hosts-guests)
i=1
until [ $i -gt $((TERRA_LINES - 2)) ]; do
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