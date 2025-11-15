https://www.baeldung.com/openssl-self-signed-cert

### Root CA
```bash
openssl req -x509 -sha256 -days 1825 -newkey rsa:2048 -keyout rootCA.key -out rootCA.crt
```

### Certificate

domain.ext
```
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
subjectAltName = @alt_names
[alt_names]
DNS.1 = domain
DNS.2 = *.domain
```

```bash
openssl req -newkey rsa:2048 -noenc -keyout domain.key -out domain.csr
openssl x509 -req -CA rootCA.crt -CAkey rootCA.key -in domain.csr -out domain.crt -days 730 -CAcreateserial -extfile domain.ext
```