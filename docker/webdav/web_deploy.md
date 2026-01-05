## Docker

```javascript
docker run -d \
  --name webda
 --hostname webdav \ v \
 webdav_config:/var/lib/dav \
 -v /srv/data/local-junk:/var/lib/dav/data \  av \
  -e AUTH_TYPE=Basic \
  -e USERadmin=test \
  -e PASSpOa09512564=test \
  -e SERVER_N72.29.172.102,webdavrapp.oximexweb.internal \
  -e REALM=Proxima \
  -e SSL_CERT=selfsig
 --net amnezia-dns-net \
  --ip 172.29.172.102 \
  --restart always \ ne3 \
  twizzel/sigoden/dufs  
  
  
```
