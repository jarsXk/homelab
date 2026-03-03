#!/bin/bash

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_RESET='\033[0m'

HEALTH_GOOD='\U1F7E2'
HEALTH_WARN='\U1F7E1'
HEALTH_BAD='\U1F534'
MOON='\U1F319'

GUEST_LINES=10

MAX_LINES=10
MAX_COLS=20

# Line (empty)
#tput smacs
#echo 'x                                               x'
#tput rmacs

left_row ()  {
  if [ $1 -eq 1 ]; then
    # Line 1 (cluster header)
    tput smacs
    echo -n 'q '
    tput rmacs
    echo -n 'Cluster'
    tput smacs
    echo -n ' qqqqqqqqqqqqqqqqqqqqqqqqqqq'
    tput rmacs
  elif [ $1 -eq 2 ]; then
    # Line 2 (cluster health)
    echo -n 'health '
    tput smacs
    echo -en $HEALTH_WARN
    tput rmacs
    echo -n ' (Hosts: 0/0 Mem: 0/0GB)    '
  elif [ $1 -eq 3 ]; then
    # Line 3 (hosts header)
    tput smacs
    echo -n 'q '
    tput rmacs
    echo -n 'Hosts'
    tput smacs
    echo -n ' qqqqqqqqqqqqqqqqqqqqqqqqqqqqq'
    tput rmacs
  else
    # Line N (hosts)
    echo -n 'host'$1
    if [ $1 -lt 10 ]; then
      echo -n ' '
    fi
    tput smacs
    echo -en ' '$HEALTH_GOOD
    tput rmacs
    echo -n ' (CPU:  0/100% Mem: 0/0GB)  '
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
    echo -n ' qqqqqqqqqqqqqqqqqqqqqqqqqqq'
    tput rmacs
  else
    echo -n 'guest'$1
    if [ $1 -lt 10 ]; then
      echo -n ' '
    fi 
    tput smacs
    echo -en ' '$HEALTH_BAD
    tput rmacs
    echo -n ' (CPU:  0/100% Mem: 0/0GB)'
  fi
} 


while [ true ]; do
  clear

  # Line 1 (header)
  tput smacs
  echo -n 'lqqqqq '
  tput rmacs
  echo -en 'Moon '$MOON
  tput smacs
  echo ' qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqk'
  tput rmacs

  # Line N (hosts-guests)
  i=1
  until [ $i -gt $MAX_LINES ]; do
    tput smacs
    echo -n 'x '
    tput rmacs 
    left_row $i $MAX_COLS
    echo -n '  '
    right_row $i $MAX_COLS
    tput smacs
    echo -n ' x'
    tput rmacs 
    echo ""

    i=$((i+1))
  done

  # Line End (header)
  tput smacs
  echo -n 'mqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqj'
  tput rmacs









  echo
  echo '+ , - . 0 ` a f g h i j k l m n o p q r s t u v w y x z { | } ~'
  tput smacs
  echo '+ , - . 0 ` a f g h i j k l m n o p q r s t u v w y x z { | } ~'
  tput rmacs


  sleep 1m
done
