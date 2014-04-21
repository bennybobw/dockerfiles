#!/bin/bash

if [ -f /var/docker/scripts/.mysql_admin_created ]; then
	echo "MySQL 'admin' user already created!"
	exit 0
fi

/usr/bin/mysqld_safe > /dev/null 2>&1 &

#PASS=$(pwgen -s 12 1)
#echo "=> Creating MySQL admin user with random password"
RET=1
while [[ RET -ne 0 ]]; do
	sleep 5
	mysql -uroot -e "CREATE USER 'admin'@'%' IDENTIFIED BY 'admin'"
	RET=$?
done

mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION"

mysqladmin -uroot shutdown

echo "=> Done!"
touch /var/docker/scripts/.mysql_admin_created

echo "========================================================================"
echo "You can now connect to this MySQL Server using:"
echo ""
echo "    mysql -uadmin -padmin -h<host> -P<port>"
echo ""
echo "Please remember to change the above password as soon as possible!"
echo "MySQL user 'root' has no password but only allows local connections"
echo "========================================================================"
