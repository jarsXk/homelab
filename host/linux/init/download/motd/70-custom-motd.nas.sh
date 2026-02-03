#!/bin/sh
echo ""
echo $(hostname) | figlet -f ANSI_Shadow
fastfetch --pipe false --disable-linewrap true --file /root/nas-ascii.txt --logo-color-1 "38;2;93;172;223" --color "38;2;93;172;223"
