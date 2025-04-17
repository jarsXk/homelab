https://github.com/gruntwork-io/health-checker

```
mkdir -p /opt/healthchecker
wget \
  -O /opt/healthchecker/healthchecker \
  https://github.com/gruntwork-io/health-checker/releases/latest/download/health-checker_linux_amd64
wget \
  --header 'Accept: application/vnd.github.v3.raw' \
  -O /opt/healthchecker/check.sh \
  https://api.github.com/repos/jarsXk/homelab/contents/host/linux/manual/healthchecker/check.sh
chmod u+x /opt/healthchecker/healthchecker
chmod u+x /opt/healthchecker/check.sh
wget \
  --header 'Accept: application/vnd.github.v3.raw' \
  -O /opt/healthchecker/healthchecker-daemon.service \
  https://api.github.com/repos/jarsXk/homelab/contents/host/linux/manual/healthchecker/healthchecker-daemon.service
ln -s /opt/healthchecker/healthchecker-daemon.service /etc/systemd/system/
systemctl start healthchecker-daemon.service
systemctl enable healthchecker-daemon.service
micro /opt/healthchecker/check.sh
systemctl status healthchecker-daemon.service

```

