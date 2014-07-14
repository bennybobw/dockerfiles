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

RUN apt-get -y -q install vim telnet wget mysql-client mysql-client-5.5 mysql-server php5-cli php5 php5-mysql php5-curl php5-gd php5-mcrypt php-apc php-pear apache2 libapache2-mod-php5 dnsmasq git
RUN a2dissite default; a2enmod ssl; a2enmod rewrite; a2enmod expires;

# Add apache script
RUN mkdir /etc/service/apache2
ADD ./runit/apache2.sh /etc/service/apache2/run
ADD ./devssl.key /etc/apache2/devssl.key
ADD ./devssl.crt /etc/apache2/devssl.crt
ADD ./conf/ports.conf /etc/apache2/ports.conf
ADD ./conf/php.ini /etc/php5/apache2/php.ini
ADD ./conf/apc.ini /etc/php5/conf.d/apc.ini

#Add mysql script
RUN mkdir /etc/service/mysql
ADD ./runit/mysql.sh /etc/service/mysql/run
ADD ./conf/my.cnf /etc/mysql/conf.d/my.cnf

# dnsmasq configuration
ADD ./conf/dnsmasq.conf /etc/dnsmasq.conf
ADD ./conf/resolv.dnsmasq.conf /etc/resolv.dnsmasq.conf
ADD ./conf/0hosts /etc/dnsmasq.d/0hosts

# add dnsmasq runit script
RUN mkdir /etc/service/dnsmasq
ADD ./runit/dnsmasq.sh /etc/service/dnsmasq/run

EXPOSE 22 80 443 3306

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
