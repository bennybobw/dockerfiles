#!/bin/bash
exec 2>&1
exec /opt/php-5.3.28/build/sbin/php-fpm --nodaemonize
