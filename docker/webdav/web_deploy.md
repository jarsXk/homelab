## Docker

```javascript
docker run -d \
  --name webdav \
  --hostname webdav \ 
  -v webdav_config:/var/lib/dav \ 
  -v /srv/data/local-junk:/var/lib/dav/data \
  -e AUTH_TYPE=Basic \
  -e USER=admin \
  -e PASS=pOa09512564 \
  -e SERVER_NAME=172.29.172.102,webdav.app.web.internal \
  -e REALM=Proxima \
  -e SSL_CERT=selfsigned \
  --net amnezia-dns-net \
  --ip 172.29.172.102 \
  --restart always \
  sigoden/dufs
```