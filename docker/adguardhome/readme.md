Preinstall
---
```
sudo mkdir -p /etc/systemd/resolved.conf.d
sudo micro /etc/systemd/resolved.conf.d/98-adguardhome.conf
sudo mv /etc/resolv.conf /etc/resolv.conf.backup
sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
sudo systemctl reload-or-restart systemd-resolved
```

98-adguardhome.conf:
```
[Resolve]
DNS=127.0.0.1
DNSStubListener=no
```
