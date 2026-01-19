## Docker

```javascript
docker run -d \
  --name adguardhome \
  --hostname adguardhome \
  -v adguardhome_work:/opt/adguardhome/work \
  -v adguardhome_conf:/opt/adguardhome/conf \
  -p 185.133.173.100:853:853/tcp \
  -p 185.133.173.100.853:853/udp \
  --net amnezia-dns-net \
  --ip 172.29.172.100 \
  --restart always \
  adguard/adguardhome
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
openssl req -new -nodes -x509 -days 365 -CA rootCA.crt -CAkey rootCA.key -keyout domain.key -out domain.crt -config domain.ext
```

### spki

```javascript
echo | openssl s_client -connect '185.133.173.100:853' 2>/dev/null | openssl x509 -pubkey -noout | openssl pkey -pubin -outform der |   openssl dgst -sha256 -binary | openssl enc -base64
```
