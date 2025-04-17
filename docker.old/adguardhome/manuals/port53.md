Port 53 already in use fix
---
```
sudo mkdir /etc/systemd/resolved.conf.d
sudo nano /etc/systemd/resolved.conf.d/adguardhome.conf
sudo mv /etc/resolv.conf /etc/resolv.conf.backup
sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
systemctl reload-or-restart systemd-resolved
```

adguardhome.conf:
```
[Resolve]
DNS=127.0.0.1
DNSStubListener=no
```
