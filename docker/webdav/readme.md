## Linux

```javascript
sudo mkdir -p /srv/data/proxima-junk
```

### fstab

```javascript
/srv/remotemount/proxima                                                                /srv/data/proxima-junk                                      none    defaults,nofail,bind   
```

## Windows

import BasicAuthLevel.reg

```javascript
net stop webclient
net start webclient
```
