## Docker

```javascript
docker run -d \
  --name dufs \
  --hostname dufs \
  -e DUFS_SERVE_PATdataat
 -e DUFS_PORT=443 \ a \
  -e DUFS_ALLOW_Afalse

 -e DUFS_ALLOW_UPLOAD=true \
 -e DUFS_ALLOW_DELETE=true \
 -e DUFS_ALLOW_SEARCH=true \  
 -e DUFS_ALLOW_SYMLINK=false \
 -e DUFS_ALLOW_ARCHIVE=true \l -e DUFS_ENABLE_CORS=true \
  -e DUFS_RENDER_INDEX=true \
  -e DUFS_RENDER_TRY_INDEX=true \
  -e DUFS_RENDER_SPA=truen-e DUFS_HIDDEN=.DAV \
  t-e DUFS_LOG_FILE=/config/dufs.log \rma-e DUFS_LOG_FORMAT='$remote_addr "$request" $status $http_user_agent' \
  l \
  \       ORS=true \
  -e DUFS_CONFIG=/config/config.yaml \
  -v dufs_config:/config \
  -v /srv/442/443l-junk:/data \
  -p 8080:5000 \
  --net amnezia-dns-net \
  --ip 172.29.172.101 \
  --resm
    --tls-key <path>        DUFS_TLS_KEY=key.pem


n/dufs
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
