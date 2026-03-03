#!/bin/sh
echo ""
echo $(hostname) | tr '[:lower:]' '[:upper:]' | figlet -f Tmplr
fastfetch --pipe false --disable-linewrap true
