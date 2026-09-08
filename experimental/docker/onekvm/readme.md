```
docker run -itd \
  --name onekvm \
  --privileged=true \
  -v /lib/modules:/lib/modules:ro \
  -v /dev:/dev \
  -v /sys/kernel/config:/sys/kernel/config \
  -v kvmd_data:/etc/kvmd \
  -v /srv/data/msd:/var/lib/kvmd/msd \
  -e OTG=1 \
  -e PASSWORD=<password> \
  -e NOSSL=1 \
  -e NOVNC=1 \
  -e NOIPMI=1 \
  -p 80:8080 \
  -p 443:4430 \
  -p 5900:5900 \
  -p 623:623 \
  --restart=always \
  silentwind0/kvmd
```