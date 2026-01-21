#!/bin/sh
# Loader for initial setup for host, VM and LXC

mkdir -p ./init-debian

wget -O ./init-debian/init-test-debian.sh https://github.com/jarsXk/homelab/raw/main/host/linux/init/init-test-debian.sh
wget -O ./init-debian/lib-check.sh https://github.com/jarsXk/homelab/raw/main/host/linux/init/lib-check.sh
wget -O ./init-debian/lib-env.sh https://github.com/jarsXk/homelab/raw/main/host/linux/init/lib-env.sh
wget -O ./init-debian/lib-helper.sh https://github.com/jarsXk/homelab/raw/main/host/linux/init/lib-helper.sh

sh ./init-debian/init-test-debian.sh

# rm -rf ./init-debian