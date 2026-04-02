#!/bin/sh
echo ""
echo $(hostname) | tr '[:lower:]' '[:upper:]' | figlet -f /usr/share/figlet/Tmplr.flf
fastfetch --pipe false --disable-linewrap true --file /root/docker-ascii.txt --logo-color-1 "38;2;29;99;237" --color "38;2;29;99;237"
