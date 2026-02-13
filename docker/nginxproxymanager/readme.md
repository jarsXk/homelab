<https://www.baeldung.com/openssl-self-signed-cert>

## RootCA

```bash
openssl req -x509 -sha256 -days 1825 -newkey rsa:2048 -keyout rootCA.key -out rootCA.crt -subj "/C=RU/ST=State/L=Locality/O=VOID/OU=Unit/CN=rootCA"
```

## Certificate

```bash
openssl req -newkey rsa:2048 -noenc -keyout domain.key -out domain.csr -subj "/C=RU/ST=State/L=Locality/O=VOID/OU=Unit/CN=domain"
openssl x509 -req -CA rootCA.crt -CAkey rootCA.key -in domain.csr -out domain.crt -days 730 -CAcreateserial
```

## Multidomain certificate

### domain.ext

```toml
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
subjectAltName = @alt_names
[alt_names]
DNS.1 = domain
DNS.2 = *.domain
```

```bash
openssl req -newkey rsa:2048 -noenc -keyout domain.key -out domain.csr -subj "/C=RU/ST=State/L=Locality/O=VOID/OU=Unit/CN=domain"
openssl x509 -req -CA rootCA.crt -CAkey rootCA.key -in domain.csr -out domain.crt -days 730 -CAcreateserial -extfile domain.ext
```
