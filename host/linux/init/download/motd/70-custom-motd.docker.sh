#!/bin/sh
echo ""
echo $(hostname) | figlet -f ANSI_Shadow
fastfetch --pipe false --disable-linewrap true --file /root/docker-ascii.txt --logo-color-1 "38;2;29;99;237" --color "38;2;29;99;237"
