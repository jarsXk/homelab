## Docker

```bash
docker run -d \
  --name webdav \
  --hostname webdav \
  -v webdav_config:/var/lib/dav \
  -v /mnt/local-junk:/var/lib/dav/data \
  -e AUTH_TYPE=Basic \
  -e USERNAME=admin \
  -e PASSWORD=<pass> \
  -e SERVER_NAME=172.29.172.102,webdav.app.web.internal \
  -e REALM=Proxima \
  -e SSL_CERT=selfsigned \
  --net amnezia-dns-net \
  --ip 172.29.172.102 \
  --restart always \
  twizzel/webdav
```