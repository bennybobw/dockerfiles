#!/bin/bash
exec 2>&1
exec /opt/php-5.5/build/sbin/php-fpm -y /opt/php-5.5/conf/php-fpm.conf --nodaemonize
