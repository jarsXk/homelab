## debian

```javascript
sudo apt update \
  && sudo apt install -y bash wget \ 
  && wget -qO- init-debian.sh https://raw.githubusercontent.com/jarsXk/homelab/main/host/linux/manual/init/init-debian.sh \
  && sudo bash init-debian.sh
```
