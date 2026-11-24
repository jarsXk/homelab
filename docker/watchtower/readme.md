## run once
```
docker run \
   --name=watchtower \
   -v /var/run/docker.sock:/var/run/docker.sock \
   nickfedor/watchtower \
   --run-once \
   --cleanup \
   --disable-containers amnezia-dns,amnezia-awg2,amnezia-xray
```
```
docker start watchtower
```
## docker api 4 remote monitor
`sudo systemctl edit docker.service`
```
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:12375
```
`sudo systemctl daemon-reload`
`sudo systemctl restart docker.service`
