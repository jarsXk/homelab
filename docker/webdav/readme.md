## Linux

```javascript
sudo mkdir -p /mnt/proxima-junk
```

### fstab

```javascript
/srv/remotemount/proxima                                                                /mnt/proxima-junk                                      none    defaults,nofail,bind   0 0
```

## Windows

import BasicAuthLevel.reg

```javascript
net stop webclient
net start webclient
```
