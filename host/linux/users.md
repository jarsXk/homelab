## groups

```
groupadd -g <gid> [--system] <group>
```

| group        | gid  | system | location                                    |
| ------------ | ---- | ------ | ------------------------------------------- |
| family       | 2000 | no     | *                                           |
| lesha-group  | 2001 | no     | *                                           |
| lena-group   | 2002 | no     | null, chanovo, shodnenskaya4, shodnenskaya5 |
| kostya-group | 2003 | no     | vasilkovo, yasenevof                        |
| tanya-group  | 2004 | no     | vasilkovo, yasenevof                        |
| dima-group   | 2005 | no     | vasilkovo                                   |
| yulia-group  | 2006 | no     | chanovo, shodnenskaya4, shodnenskaya5       |
| docker       | 199  | yes    |                                             |
## users

```
useradd --uid <uid> --gid <group> [-G <extragroup1>[,<extragroup2>][][,sudo]] --shell <shell> [--[no-]create-home] [--system] <user>
```

| login    | ui   | group | sudo | shell             | create home | system | extra groups                                                                  | location                                    |
| -------- | ---- | ----- | ---- | ----------------- | ----------- | ------ | ----------------------------------------------------------------------------- | ------------------------------------------- |
| lesha    | 2001 | users | yes  | /bin/bash         | yes         | no     | lesha-group,\_ssh,family                                                      | *                                           |
| lena     | 2002 | users | no   | /bin/bash         | yes         | no     | lena-group,\_ssh,family                                                       | null, chanovo, shodnanskaya4, shodnenskaya5 |
| kostya   | 2003 | users | yes  | /bin/bash         | yes         | no     | kostya-group,\_ssh,family                                                     | vasilkovo, yasenevof                        |
| tanya    | 2004 | users | no   | /usr/sbin/nologin | yes         | no     | tanya-group,family                                                            | vasilkovo, yasenevof                        |
| dima     | 2005 | users | no   | /bin/bash         | yes         | no     | dima-group,\_ssh,family                                                       | vasilkovo                                   |
| yulia    | 2006 | users | no   | /usr/sbin/nologin | yes         | no     | yulia-group,family                                                            | chanovo, shodnanskaya4, shodnenskaya5       |
| docker   | 1999 | users | no   | /usr/sbin/nologin | no          | yes    | docker,lesha-group,lena-group,kostya-group,tanya-group,dima-group,yulia-group |                                             |
| internal | 1998 | users | no   | /usr/sbin/nologin | no          | yes    |                                                                               | *                                           |
| amnezia  | 1997 | users | yes  | /bin/bash         | no          | yes    | \_ssh                                                                         | web                                         |
| monitor  | 1996 | users | no   | /bin/bash         | yes         | yes    | \_ssh                                                                         |                                             |
