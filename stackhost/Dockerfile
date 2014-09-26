# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:latest
MAINTAINER Ben Wheeler <bwheeler@giantrabbit.com>

# Set correct environment variables.
ENV HOME /root

RUN apt-get update && apt-get upgrade -y

##ADD AFTER THIS LINE

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
# RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

## Uncomment this to enable the insecure key.
RUN /usr/sbin/enable_insecure_key

RUN apt-get -y -q install vim telnet wget mysql-client mysql-client-5.5 mysql-server apache2 dnsmasq git subversion libmcrypt-dev libreadline6 libreadline6-dev libgd2-xpm-dev
RUN apt-get -y -q build-dep php5
RUN a2dissite default; a2enmod ssl; a2enmod rewrite; a2enmod expires; a2enmod proxy_fcgi;


#download and compile php5-fpm
RUN mkdir /tmp/php-5.5
WORKDIR /tmp/php-5.5
ADD ./build/php-fpm-5.5-build.sh /tmp/php-5.5/php-fpm-5.5-build.sh
RUN /tmp/php-5.5/php-fpm-5.5-build.sh

#download and compile php5-fpm
RUN mkdir /tmp/php-5.3
WORKDIR /tmp/php-5.3
ADD ./build/php-fpm-5.3-build.sh /tmp/php-5.3/php-fpm-5.3-build.sh
RUN /tmp/php-5.3/php-fpm-5.3-build.sh

# Add apache script
RUN mkdir /etc/service/apache2
RUN mkdir -p /var/lock/apache2
ADD ./runit/apache2.sh /etc/service/apache2/run
ADD ./devssl.key /etc/apache2/devssl.key
ADD ./devssl.crt /etc/apache2/devssl.crt
ADD ./conf/ports.conf /etc/apache2/ports.conf
ADD ./conf/000-default.conf /etc/apache2/sites-available/000-default.conf

#Add mysql script
RUN mkdir /etc/service/mysql
ADD ./runit/mysql.sh /etc/service/mysql/run
ADD ./conf/my.cnf /etc/mysql/conf.d/my.cnf

# dnsmasq configuration
ADD ./conf/dnsmasq.conf /etc/dnsmasq.conf
ADD ./conf/resolv.dnsmasq.conf /etc/resolv.dnsmasq.conf
#ADD ./conf/0hosts /etc/dnsmasq.d/0hosts

# add dnsmasq runit script
RUN mkdir /etc/service/dnsmasq
ADD ./runit/dnsmasq.sh /etc/service/dnsmasq/run

#add php-fpm conf
RUN mkdir /etc/service/php-fpm/
ADD ./conf/php.ini /opt/php-5.5/conf/php.ini
ADD ./conf/php-fpm.conf /opt/php-5.5/conf/php-fpm.conf
ADD ./runit/php-fpm.sh /etc/service/php-fpm/run
RUN mkdir /opt/php-5.5/conf/pools.d
ADD ./conf/php-www-pool.conf /opt/php-5.5/conf/pools.d/www-pool.conf

#add php-fpm-5.3 conf
RUN mkdir /etc/service/php-fpm-5.3/
ADD ./conf/php.ini /opt/php-5.3/conf/php.ini
ADD ./conf/php-fpm.conf /opt/php-5.3/conf/php-fpm.conf
ADD ./runit/php-fpm-5.3.sh /etc/service/php-fpm-5.3/run
RUN mkdir /opt/php-5.3/conf/pools.d

#change refs to php-5.3 in conf files
ADD ./conf/php-www-pool.conf /opt/php-5.3/conf/pools.d/www-pool.conf
RUN sed -i -e s/php-5.5/php-5.3/g /opt/php-5.3/conf/php-fpm.conf
RUN sed -i -e s/php-fpm.log/php-fpm-5.3.log/g /opt/php-5.3/conf/php-fpm.conf
RUN sed -i -e s/php-5.5/php-5.3/g /opt/php-5.3/conf/php.ini
RUN sed -i -e s/9000/9001/g /opt/php-5.3/conf/pools.d/www-pool.conf

EXPOSE 22 80 443 3306

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
