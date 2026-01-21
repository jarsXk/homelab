#!/bin/sh
# Loader for initial setup for host, VM and LXC

mkdir -p ./init-debian
cd ./init-debian

wget https://github.com/jarsXk/homelab/raw/main/host/linux/init/init-test-debian.sh
wget https://github.com/jarsXk/homelab/raw/main/host/linux/init/lib-check.sh
wget https://github.com/jarsXk/homelab/raw/main/host/linux/init/lib-env.sh
wget https://github.com/jarsXk/homelab/raw/main/host/linux/init/lib-helper.sh

sh init-test-debian.sh

cd ..
rm -rf ./init-debian