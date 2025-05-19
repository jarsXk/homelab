```
docker network create \
  --subnet=198.19.1.0/24 \
  --gateway=198.19.1.1 \
  portainer_net
```
```
docker run -d \
  -p 30130:9001 \
  --name portaineragent \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/snap/docker/common/var-lib-docker/volumes:/var/lib/docker/volumes \
  --restart=always \
  --network portainer_net \
  --ip 198.19.1.3 \
  portainer/agent:alpine
```
```
docker run -d \
  --name=portainer \
  -p 8000:8000 \
  -p 30120:9000 \
  -p 30124:9443 \
  -v portainer_data:/data \
  --network portainer_net \
  --ip 198.19.1.2 \
  --restart=always \
  portainer/portainer-ce:alpine
```