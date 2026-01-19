## groups

| group  | gid  | system |
| -----  | ---- | ------ |
| family | 2000 | no     |
| lesha-group | 2001 | no     |
| lena-group | 2002 | no     |

create_group	  lesha-group  no        2001 
if [ $NAS = yes ] && [ $LOCATION = kommunarka ]; then
  create_group	lena-group   no        2002
fi
if [ $LOCATION = vasilkovo ]; then
  create_group	kostya-group no        2003
fi
if [ $NAS = yes ] && [ $LOCATION = vasilkovo ]; then
  create_group	tanya-group  no        2004
  create_group	dima-group   no        2005
fi
if [ $NAS = yes ] && [ $LOCATION = chanovo ]; then
  create_group	lena-group   no        2002
  create_group	yulia-group  no        2006
fi
if [ $LOCATION = yasenevof ]; then
  create_group	kostya-group no        2003
fi
if [ $NAS = yes ] && [ $LOCATION = shodnenskaya ]; then
  create_group	lena-group   no        2002
  create_group	yulia-group  no        2006
fi

```
groupadd -g <gid> [--system] <group>
```

## users

| login  | ui   | group | sudo | shell     | create home | system | extra groups              |
| ------ | ---- | ----- | ---- | --------- | ----------- | ------ | ------------------------- |
| lesha  | 2001 | users | yes  | /bin/bash | yes         | no     | lesha-group,\_ssh,family  |
| lena   | 2002 | users | no   | /bin/bash | yes         | no     | lena-group,\_ssh,family   |
| kostya | 2003 | users | yes  | /bin/bash | yes         | no     | kostya-group,\_ssh,family |



if \[ $LOCATION = vasilkovo ]; then
create\_user kostya       2003 users    yes  /bin/bash         yes         no        kostya-group,\_ssh$FAMILY\_GROUP
DOCKER\_GROUPS="$DOCKER\_GROUPS,kostya-group"
fi
if \[ $NAS = yes ] && \[ $LOCATION = vasilkovo ]; thencreate\_user tanya        2004 users    no   /usr/sbin/nologin yes         no        tanya-group$FAMILY\_GROUP
create\_user dima         2005 users    no   /bin/bash         yes         no        dima-group,\_ssh$FAMILY\_GROUP
DOCKER\_GROUPS="$DOCKER\_GROUPS,tanya-group,dima-group"
fi
if \[ $NAS = yes ] && \[ $LOCATION = chanovo ]; then
create\_user lena         2002 users    no   /bin/bash         yes         no        lena-group,\_ssh$FAMILY\_GROUP
create\_user yulia        2006 users    no   /usr/sbin/nologin yes         no        yulia-group$FAMILY\_GROUP
DOCKER\_GROUPS="$DOCKER\_GROUPS,lena-group,yulia-group"
fi
if \[ $LOCATION = yasenevof ]; then
create\_user kostya       2003 users    yes  /bin/bash         yes         no        kostya-group,\_ssh$FAMILY\_GROUP
DOCKER\_GROUPS="$DOCKER\_GROUPS,kostya-group"
fi
if \[ $NAS = yes ] && \[ $LOCATION = shodnenskaya ]; then
create\_user lena         2002 users    no   /bin/bash         yes         no        lena-group,\_ssh$FAMILY\_GROUP
create\_user yulia        2006 users    no   /usr/sbin/nologin yes         no        yulia-group$FAMILY\_GROUP
DOCKER\_GROUPS="$DOCKER\_GROUPS,lena-group,yulia-group"
fi
\==ate\_user docker       1999 users    no   /usr/sbin/nologin no          yes       $DOCKER\_GROUPS
fi
if \[ $NAS = yes ]; then
create\_user internal     1998 users    no   /usr/sbin/nologin no          yes
fi

# create\_user amnezia      1997 users    yes  /bin/bash         yes         yes

```
useradd --uid <uid> --gid <group> [-G <extragroup1>[,<extragroup2>][][,sudo]] --shell <shell> [--[no-]create-home] [--system] <user>
```
