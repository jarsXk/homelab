
# Creating groups
log_message INFO "Creating groups"
#               name         is_system gid  
if [ $NAS = yes ]; then
  create_group  family       no        2000
fi
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