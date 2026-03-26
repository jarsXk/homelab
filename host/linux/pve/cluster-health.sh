#!/bin/bash

while [ true ]; do
  clear

  . ./cluster-health-refresh.sh

  sleep 60s
done
