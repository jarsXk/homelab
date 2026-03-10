
# Creating users
log_message INFO "Creating users"
DOCKER_GROUPS="docker"
FAMILY_GROUP=""
if [ "$SERVER_ROLE" = "nas" ]; then
  DOCKER_GROUPS="$DOCKER_GROUPS,family"
  FAMILY_GROUP=",family"
fi

# real users
#               login      uid  group    sudo shell             create_home is_system extra_groups
if [ "$SERVER_ROLE" != "proxmox" ]; then
  USER_GROUP=",lesha-group"
  DOCKER_GROUPS="$DOCKER_GROUPS,lesha-group"
fi
#               login      uid  group    sudo shell             create_home is_system extra_groups
create_user     lesha      2001 users    yes  /bin/bash         yes         no        _ssh$USER_GROUP$FAMILY_GROUP
if [ "$SERVER_ROLE" = "nas" ] && [ "$LOCATION" = "null" ]; then
  if [ "$SERVER_ROLE" != "proxmox" ]; then
    USER_GROUP=",lena-group"
    DOCKER_GROUPS="$DOCKER_GROUPS,lena-group"
  fi
#               login      uid  group    sudo shell             create_home is_system extra_groups
  create_user   lena       2002 users    no   /bin/bash         yes         no        _ssh$USER_GROUP$FAMILY_GROUP
fi
if [ $LOCATION = vasilkovo ]; then
  if [ "$SERVER_ROLE" != "proxmox" ]; then
    USER_GROUP=",kostya-group"
    DOCKER_GROUPS="$DOCKER_GROUPS,kostya-group"
  fi
#               login      uid  group    sudo shell             create_home is_system extra_groups  
  create_user   kostya     2003 users    yes  /bin/bash         yes         no        _ssh$USER_GROUP$FAMILY_GROUP
fi
if [ "$SERVER_ROLE" = "nas" ] && [ "$LOCATION" = "vasilkovo" ]; then  
  if [ "$SERVER_ROLE" != "proxmox" ]; then
    USER_GROUP=",tanya-group"
    DOCKER_GROUPS="$DOCKER_GROUPS,tanya-group"
  fi
#               login      uid  group    sudo shell             create_home is_system extra_groups   
  create_user   tanya      2004 users    no   /usr/sbin/nologin yes         no        _ssh$USER_GROUP$FAMILY_GROUP
  if [ "$SERVER_ROLE" != "proxmox" ]; then
    USER_GROUP=",dima-group"
    DOCKER_GROUPS="$DOCKER_GROUPS,dima-group"
  fi
#               login      uid  group    sudo shell             create_home is_system extra_groups   
  create_user   dima       2005 users    no   /bin/bash         yes         no        _ssh$USER_GROUP$FAMILY_GROUP
fi
if [ "$SERVER_ROLE" = "nas" ] && [ "$LOCATION" = "chanovo" ]; then
  if [ "$SERVER_ROLE" != "proxmox" ]; then
    USER_GROUP=",lena-group"
    DOCKER_GROUPS="$DOCKER_GROUPS,lena-group"
  fi
#               login      uid  group    sudo shell             create_home is_system extra_groups   
  create_user   lena       2002 users    no   /bin/bash         yes         no        _ssh$USER_GROUP$FAMILY_GROUP
  if [ "$SERVER_ROLE" != "proxmox" ]; then
    USER_GROUP=",yulia-group"
    DOCKER_GROUPS="$DOCKER_GROUPS,yulia-group"
  fi
#               login      uid  group    sudo shell             create_home is_system extra_groups   
  create_user   yulia      2006 users    no   /usr/sbin/nologin yes         no        _ssh$USER_GROUP$FAMILY_GROUP
fi
if [ $LOCATION = yasenevof ]; then
  if [ "$SERVER_ROLE" != "proxmox" ]; then
    USER_GROUP=",kostya-group"
    DOCKER_GROUPS="$DOCKER_GROUPS,kostya-group"
  fi
#               login      uid  group    sudo shell             create_home is_system extra_groups  
  create_user   kostya     2003 users    yes  /bin/bash         yes         no        _ssh$USER_GROUP$FAMILY_GROUP
fi
if [ "$SERVER_ROLE" = "nas" ] && [ "$LOCATION" = "shodnenskaya" ]; then
  if [ "$SERVER_ROLE" != "proxmox" ]; then
    USER_GROUP=",lena-group"
    DOCKER_GROUPS="$DOCKER_GROUPS,lena-group"
  fi
#               login      uid  group    sudo shell             create_home is_system extra_groups   
  create_user   lena       2002 users    no   /bin/bash         yes         no        _ssh$USER_GROUP$FAMILY_GROUP
  if [ "$SERVER_ROLE" != "proxmox" ]; then
    USER_GROUP=",yulia-group"
    DOCKER_GROUPS="$DOCKER_GROUPS,yulia-group"
  fi
#               login      uid  group    sudo shell             create_home is_system extra_groups   
  create_user   yulia      2006 users    no   /usr/sbin/nologin yes         no        _ssh$USER_GROUP$FAMILY_GROUP
fi
# technical users
#             login        uid  group    sudo shell             create_home is_system extra_groups
if [ "$DOCKER" = "yes" ]; then
  create_user docker       1999 users    no   /usr/sbin/nologin no          yes       $DOCKER_GROUPS
fi
if [ "$SERVER_ROLE" = "nas" ]; then
  create_user internal     1998 users    no   /usr/sbin/nologin no          yes
fi
# create_user amnezia      1997 users    yes  /bin/bash         yes         yes
