#!/bin/sh
echo ""
echo $(hostname) | tr '[:lower:]' '[:upper:]' | figlet -f /usr/share/figlet/Tmplr.flf
fastfetch --pipe false --disable-linewrap true --file /root/nas-ascii.txt --logo-color-1 "38;2;93;172;223" --color "38;2;93;172;223"
