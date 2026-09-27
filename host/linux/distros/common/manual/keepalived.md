# Init keepalived

**debian/ubuntu:**

apt install -y keepalived
nano /etc/keepalived/keepalived.conf
systemctl start keepalived
systemctl status keepalived
systemctl enable keepalived

**alpine:**
apk add keepalived
mkdir /etc/keepalived/
nano /etc/keepalived/keepalived.conf
rc-service keepalived start
rc-service keepalived status
rc-update add keepalived

### keepalived.conf

```
vrrp_instance VI_1 {
  state <MASTER/BACKUP>
  interface <interface | ip a | eth0>
  virtual_router_id <id | ip address>
  priority <75/50/25>
  advert_int 10
  authentication {
    auth_type PASS
    auth_pass <password>
  }
  unicast_src_ip <host ip>
  unicast_peer {
    <peer ip>
  }
  virtual_ipaddress {
    <vrrp ip>
  }
}
```
