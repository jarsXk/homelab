#!/bin/sh
echo ""
echo $(hostname) | figlet -f ANSI_Shadow
fastfetch --pipe false --disable-linewrap true
