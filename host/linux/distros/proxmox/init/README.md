## proxmox

```bash
apt update \
  && apt install -y bash wget \
  && bash <(wget -qO- https://raw.githubusercontent.com/jarsXk/homelab/main/host/linux/distros/proxmox/init/init-proxmox.sh)
```
