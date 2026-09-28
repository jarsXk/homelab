```
apt install -y snapper
mv /lib/systemd/system/snapper-timeline.timer /lib/systemd/system/snapper-timeline.timer.bak
wget \
  --header 'Accept: application/vnd.github.v3.raw' \
  -O /lib/systemd/system/snapper-timeline.timer \
  https://api.github.com/repos/jarsXk/homelab/contents/host/linux/manual/snapper/snapper-timeline.timer
systemctl daemon-reload
systemctl restart snapper-timeline.timer
wget \
  --header 'Accept: application/vnd.github.v3.raw' \
  -O /usr/local/bin/snapperlist \
  https://api.github.com/repos/jarsXk/homelab/contents/host/linux/manual/snapper/snapperlist
chmod a+rx /usr/local/bin/snapperlist
```
```
umount /.snapshots
rmdir /.snapshots
snapper -c root create-config /
btrfs subvolume delete .snapshots
mkdir /.snapshots
mount /.snapshots
mv /etc/snapper/configs/root /etc/snapper/configs/root.bak
wget \
  --header 'Accept: application/vnd.github.v3.raw' \
  -O /etc/snapper/configs/root \
  https://api.github.com/repos/jarsXk/homelab/contents/host/linux/manual/snapper/configs/root
```
```
cd /mnt/local-pve
umount /mnt/local-pve/.snapshots
rmdir /mnt/local-pve/.snapshots
snapper -c pve create-config /mnt/local-pve
btrfs subvolume delete .snapshots
mkdir /mnt/local-pve/.snapshots
mount /mnt/local-pve/.snapshots
mv /etc/snapper/configs/pve /etc/snapper/configs/pve.bak
wget \
  --header 'Accept: application/vnd.github.v3.raw' \
  -O /etc/snapper/configs/pve \
  https://api.github.com/repos/jarsXk/homelab/contents/host/linux/manual/snapper/configs/pve
```