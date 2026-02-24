## run once
```
docker run \
   --name=watchtower \
   -v /var/run/docker.sock:/var/run/docker.sock \
   containrrr/watchtower \
   --run-once \
   --cleanup \ 
   --disable-containers amnezia-awg,amnezia-awg2,amnezia-xray
```
```
docker start watchtower
```