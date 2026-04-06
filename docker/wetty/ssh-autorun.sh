#!/bin/sh

echo "Host to connect:"
echo "  1 - terra.lan"
echo "  2 - luna.lan"
echo "  3 - selena.lan"
echo ""
echo "  5 - phaeton.lan"
echo "  6 - moon-admin.lan"
echo "  7 - moon-dns.lan"
echo "  8 - moon-proxy.lan"
echo "  c - cancel"

while [ "$HOST" = "" ]; do
  read -rp "Host (1-3,5-8,c): " CHOICE

  case "$CHOICE" in
    1) HOST="terra.lan"; break ;;
    2) HOST="luna.lan"; break ;;
    3) HOST="selena.lan"; break ;;
    5) HOST="phaeton.lan"; break ;;
    6) HOST="moon-admin.lan"; break ;;
    7) HOST="moon-dns.lan"; break ;;
    8) HOST="moon-proxy.lan"; break ;;
    c) echo "Cancelled connection."; exit 1 ;;
    *) echo "Incorrect input. Enter 1-3, 5-8 or c." ;;
  esac
done

while [ "$SSHUSER" = "" ]; do
  read -rp "User: " SSHUSER
done

exec ssh "${SSHUSER}@${HOST}"
