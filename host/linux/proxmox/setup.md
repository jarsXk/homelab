- ceph: https://gist.github.com/aelhusseiniakl/39e3fd9f29abda6153a3b5a0a5bc191b
- temperatures: https://help.rackzar.com/en/knowledgebase/article/how-to-monitor-cpu-temps-and-fan-speeds-in-proxmox-virtual-environment
- thunderbolt net: https://gist.github.com/karubits/787632319e529066a81d1192d879834c
- intel vgpu: https://github.com/strongtz/i915-sriov-dkms https://www.derekseaman.com/2024/07/proxmox-ve-8-2-windows-11-vgpu-vt-d-passthrough-with-intel-alder-lake.html
- kernel clean: `bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/tools/pve/kernel-clean.sh)"`
- vm routes alpine
  /etc/network/interfaces
```c
up   route add 198.18.160.20 gw 172.20.2.20 dev eth0
up   route add 198.18.160.21 gw 172.20.2.21 dev eth0
up   route add 198.18.160.22 gw 172.20.2.22 dev eth0
```
- vm routes debian13
  /etc/netplan/90-default.yaml
```c
      routes:
        - to: 198.18.160.20
          via: 172.20.2.20
          metric: 100
        - to: 198.18.160.21
          via: 172.20.2.21
          metric: 100
        - to: 198.18.160.22
          via: 172.20.2.22
          metric: 100
```
- 
