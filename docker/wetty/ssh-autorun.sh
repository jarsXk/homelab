#!/bin/sh

echo "Host to connect:"
echo "  1 - terra.lan"
echo "  2 - mani.lan"
echo "  3 - luna.lan"
echo "  4 - selena.lan"
echo "  5 - hina.lan"
echo "  6 - phaeton.lan"
echo "  7 - moonadmin.lan"
echo "  8 - moonload.lan"
echo "  9 - moonmedia.lan"
echo "  0 - moondocs.lan"
echo "  - - moondns.lan"
echo "  = - moonproxy.lan"
echo "  c - cancel"

while [ "$HOST" = "" ]; do
  read -rp "Host (1-9,0,-,=,c): " CHOICE

  case "$CHOICE" in
    1) HOST="terra.lan"; break ;;
    2) HOST="mani.lan"; break ;;
    3) HOST="luna.lan"; break ;;
    4) HOST="selena.lan"; break ;;
    5) HOST="hina.lan"; break ;;
    6) HOST="phaeton.lan"; break ;;
    7) HOST="moonadmin.lan"; break ;;
    8) HOST="moonload.lan"; break ;;
    9) HOST="moonmedia.lan"; break ;;
    0) HOST="moondocs.lan"; break ;;
    -) HOST="moondns.lan"; break ;;
    =) HOST="moonproxy.lan"; break ;;
    c) echo "Cancelled connection."; exit 1 ;;
    *) echo "Incorrect input. Enter 1-3, 5-8 or c." ;;
  esac
done

while [ "$SSHUSER" = "" ]; do
  read -rp "User: " SSHUSER
done

exec ssh "${SSHUSER}@${HOST}"
