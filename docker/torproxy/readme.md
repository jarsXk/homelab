```
sudo mkdir -p /srv/docker/assets/torproxy
sudo wget \
  -O /srv/docker/assets/torproxy/torrc \
  https://raw.githubusercontent.com/jarsXk/homelab/refs/heads/main/docker/torproxy/assets/torrc
sudo wget \
  -O /srv/docker/assets/torproxy/bridges.txt \
  https://raw.githubusercontent.com/jarsXk/homelab/refs/heads/main/docker/torproxy/assets/bridges.txt
```