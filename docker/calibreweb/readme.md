```
sudo mkdir -p /srv/docker/assets/calibreweb
sudo wget \
  -O /srv/docker/assets/calibreweb/xdg-desktop-menu \
  https://raw.githubusercontent.com/jarsXk/homelab/refs/heads/main/docker/calibreweb/assets/xdg-desktop-menu
sudo wget \
  -O /srv/docker/assets/calibreweb/xdg-icon-resource \
  https://raw.githubusercontent.com/jarsXk/homelab/refs/heads/main/docker/calibreweb/assets/xdg-icon-resource
sudo wget \
  -O /srv/docker/assets/calibreweb/xdg-mime \
  https://raw.githubusercontent.com/jarsXk/homelab/refs/heads/main/docker/calibreweb/assets/xdg-mime
sudo chmod a+x /srv/docker/assets/calibreweb/*
```