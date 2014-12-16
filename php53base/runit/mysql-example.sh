#!/bin/sh

if [ ! -f /var/lib/mysql/ibdata1 ]; then
    echo "=> Initializing database"
    /usr/bin/mysql_install_db

    echo "=> Creating MySQL admin user with random password"
    /usr/bin/mysqld_safe > /dev/null 2>&1 &

    ## make sure mysqld actually starts and we can connect to it
    ## before proceeding
    while ! nc -vz localhost 3306; do
        sleep 0.2
    done

    ## generate a new admin password
    PASS=$(pwgen -s 12 1)

    ## create admin user and secure the install
    mysql -uroot -e "
        CREATE USER 'admin'@'%' IDENTIFIED BY '$PASS';
        GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;
        DELETE FROM mysql.user WHERE User='';
        DELETE FROM mysql.user WHERE User='root' AND Host!='localhost';
        DROP DATABASE test;
        DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
        FLUSH PRIVILEGES;
    "

    MYSQLD_PID=$(cat /var/run/mysqld/mysqld.pid)
    mysqladmin shutdown

    ## ensure the process has halted before proceeding, or we will
    ## end up with two daemons, and endless restart loop because of conflict
    while kill -0 $MYSQLD_PID 2> /dev/null; do
        sleep 0.2
    done

    echo "=> Done!"

    ## get IP of the current container
    IP=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')

    echo "========================================================================"
    echo "You can now connect to this MySQL Server using:"
    echo ""
    echo " mysql -uadmin -p$PASS -h$IP -P<port>"
    echo ""
    echo "Please remember to change the above password as soon as possible!"
    echo "MySQL user 'root' has no password but only allows local connections"
    echo "========================================================================"
fi

## this is borrowed from the runit docs, and it seems to work
## http://smarden.org/runit1/runscripts.html#mysql
## otherwise mysqld_safe seems to trap signals and never wants to shutdown
trap '/usr/bin/mysqladmin shutdown' 0
trap 'exit 2' 1 2 3 15

echo '=> Starting daemon'
exec /usr/bin/mysqld_safe & wait

## end
