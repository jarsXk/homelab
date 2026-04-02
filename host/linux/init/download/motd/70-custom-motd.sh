#!/bin/sh
echo ""
echo $(hostname) | tr '[:lower:]' '[:upper:]' | figlet -f /usr/share/figlet/Tmplr.flf
fastfetch --pipe false --disable-linewrap true
