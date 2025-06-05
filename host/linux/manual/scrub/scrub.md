```
wget \
  --header 'Accept: application/vnd.github.v3.raw' \
  -O /usr/local/sbin/scrub-btrfs.sh \
  https://api.github.com/repos/jarsXk/homelab/contents/host/linux/manual/scrub/scrub-btrfs.sh
chmod ug+x /usr/local/sbin/scrub-btrfs.sh
wget \
  --header 'Accept: application/vnd.github.v3.raw' \
  -O /etc/cron.d/scrub-btrfs \
  https://api.github.com/repos/jarsXk/homelab/contents/host/linux/manual/scrub/scrub-btrfs

```