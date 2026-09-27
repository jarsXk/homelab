## debian

```bash
apt update \
  && apt install -y bash wget \
  && bash <(wget -qO- https://raw.githubusercontent.com/jarsXk/homelab/main/host/linux/init/init-debian.sh)
```

## proxmox

```bash
apt update \
  && apt install -y bash wget \
  && bash <(wget -qO- https://raw.githubusercontent.com/jarsXk/homelab/main/host/linux/init/init-proxmox.sh)
```

## alpine
```bash
apk update && apk add bash wget && bash <(wget -qO- https://raw.githubusercontent.com/jarsXk/homelab/main/host/linux/init/init-alpine.sh)
```