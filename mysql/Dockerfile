FROM ubuntu:12.04
MAINTAINER Ben Wheeler <bwheeler@giantrabbit.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

# Do NOT change above this line, so that Docker caches correctly
# http://crosbymichael.com/dockerfile-best-practices.html
# install php and mysql
RUN	bash -c "export DEBIAN_FRONTEND=noninteractive; apt-get -q -y install supervisor mysql-server pwgen vim openssh-server; mkdir /var/run/sshd"

# Add image configuration and scripts
ADD ./scripts  /var/docker/scripts
ADD ./conf/supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf
ADD ./conf/supervisord-openssh.conf /etc/supervisor/conf.d/supervisord-openssh.conf
ADD ./conf/my.cnf /etc/mysql/conf.d/my.cnf

RUN chmod 755 /var/docker/scripts/*.sh

EXPOSE 22
EXPOSE 3306
CMD ["/var/docker/scripts/run.sh"]
