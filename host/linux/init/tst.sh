#!/bin/sh

INIT_REPO=https://raw.githubusercontent.com/jarsXk/homelab/main/host/linux

echo !!Start

wget -O - ${INIT_REPO}/init/lib-tst.sh > /dev/null | cat /dev/stdin
wget -O - ${INIT_REPO}/init/lib-tst.sh | . /dev/stdin

echo !!$TSTMES
echo !!End