## Preinstall

```javascript
sudo mkdir -p /etc/systemd/resolved.conf.d
sudo micro /etc/systemd/resolved.conf.d/98-adguardhome.conf
sudo mv /etc/resolv.conf /etc/resolv.conf.backup
sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
sudo systemctl reload-or-restart systemd-resolved
```

98-adguardhome.conf:

```javascript
[Resolve]
DNS=127.0.0.1
DNSStubListener=no
```

## Docker install

```javascript
docker network create \
  --subnet=198.19.2.0/24 \
  --gateway=198.19.2.1 \
  portainer_net
```

```javascript
docker run \
  --name adguardhome \
  --restart unless-stopped \
  -v adguardhome_work:/opt/adguardhome/work \
  -v adguardhome_conf:/opt/adguardhome/conf \
  -p <host>:53:53/tcp -p <host>:53:53/udp \
  -p 67:67/udp -p 68:68/udp \
  -p 80:80/tcp -p 443:443/tcp -p 443:443/udp -p 3000:3000/tcp \
  -p 853:853/tcp \
  -p 784:784/udp -p 853:853/udp -p 8853:8853/udp \
  -p 5443:5443/tcp -p 5443:5443/udp \
  -d adguard/adguardhome
```
