## debian

```javascript
apt update \
  && apt install -y bash wget \
  && bash <(wget -qO- https://raw.githubusercontent.com/jarsXk/homelab/main/host/linux/init/init-debian.sh)
```
