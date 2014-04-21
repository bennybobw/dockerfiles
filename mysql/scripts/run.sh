#!/bin/bash
if [ ! -f /.mysql_admin_created ]; then
	/var/docker/scripts/create_mysql_admin_user.sh
fi
exec supervisord -n
