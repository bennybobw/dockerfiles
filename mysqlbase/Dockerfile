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

RUN apt-get -y -q install vim telnet wget mysql-server 

#Add apache script
RUN mkdir /etc/service/mysql
ADD ./mysql.sh /etc/service/mysql/run
ADD ./my.cnf /etc/mysql/conf.d/my.cnf

EXPOSE 22 3306

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
