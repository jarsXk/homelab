## Docker

```javascript
docker run -d \
  --name dufs \
  --hostname dufs \
  -e DUFS_SERVE_PATH=/data \
  -e DUFS_HIDDEN=.DAV \
  -e DUFS_PORT=443 \
  -e DUFS_ALLOW_ALL=false
  -e DUFS_ALLOW_UPLOAD=true \
  -e DUFS_ALLOW_DELETE=true \
  -e DUFS_ALLOW_SEARCH=true \  
  -e DUFS_ALLOW_SYMLINK=false \
  -e DUFS_ALLOW_ARCHIVE=true \
  -e DUFS_ALLOW_HASH=true \
  -e DUFS_ENABLE_CORS=true \
  -e DUFS_RENDER_INDEX=true \
  -e DUFS_RENDER_TRY_INDEX=true \
  -e DUFS_RENDER_SPA=true \
  -e DUFS_LOG_FILE=/config/dufs.log \
  -e DUFS_LOG_FORMAT='$remote_addr "$request" $status $http_user_agent' \
  -e DUFS_ENABLE_CORS=true \
  -e DUFS_CONFIG=/config/config.yaml \
  -v dufs_config:/config \
  -v /srv/data/local-junk:/data \
  -p 442/443 \
  --net amnezia-dns-net \
  --ip 172.29.172.101 \
  --restart always \
  sigoden/dufs
```

## DNS certificate

### domain.ext

```javascript
[req]
default_bits = 4096
default_md = sha256
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no

[req_distinguished_name]
C = RU
ST = State
L = Locality
O = VOID
OU = Unit
CN = 192.168.1.1  # Replace with your IP address

[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
IP.1 = 192.168.1.1  # Replace with your IP address
```

```javascript
openssl req -new -nodes -x509 -days 365 -keyout domain.key -out domain.crt -config domain.ext
```
