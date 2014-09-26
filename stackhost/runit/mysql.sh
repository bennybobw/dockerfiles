#!/bin/bash
exec 2>&1
if [ ! -d "/var/lib/mysql/performance_schema" ]; then
  if [ -d "/var/lib/mysql" ]; then
    chown -R mysql:mysql /var/lib/mysql
    mysql_install_db
  fi
fi
if [ -d "/var/lib/mysql" ]; then
  chown -R mysql:mysql /var/lib/mysql
fi

#from http://smarden.org/runit1/runscripts.html#mysql
cd /
umask 077

MYSQLADMIN='/usr/bin/mysqladmin --defaults-extra-file=/etc/mysql/debian.cnf'

trap "$MYSQLADMIN shutdown" 0
trap 'exit 2' 1 2 3 15

/usr/bin/mysqld_safe & wait
