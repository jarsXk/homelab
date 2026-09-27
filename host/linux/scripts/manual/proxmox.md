## common
### Remove subscription message
```
sed -Ezi.bak "s/(function\(orig_cmd\) \{)/\1\n\torig_cmd\(\);\n\treturn;/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js && systemctl restart pveproxy.service
```
### Kill single-node cluster
```
systemctl stop pve-cluster corosync  
pmxcfs -l  
rm /etc/corosync/*  
rm /etc/pve/corosync.conf  
killall pmxcfs  
rm /var/lib/corosync/*
systemctl start pve-cluster
```

## amd64
### Install on Debian 12
https://pve.proxmox.com/wiki/Install_Proxmox_VE_on_Debian_12_Bookworm

### Docker in prividged LXC
```
lxc.apparmor.profile: unconfined
lxc.cgroup2.devices.allow: a
lxc.cap.drop:
```

## arm64
### Debian arm64 lxc
```
dhclient && \
apt update && \
apt install ifupdown2 -y && \
apt upgrade -y && \
ip -c a
