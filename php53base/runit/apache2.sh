#!/bin/bash
[ -d /var/run/apache2 ] || mkdir /var/run/apache2  
source /etc/apache2/envvars
exec /usr/sbin/apache2 -DNO_DETACH
