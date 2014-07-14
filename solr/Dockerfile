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

RUN apt-get -y -q install vim telnet wget sed rsync java7-jdk

WORKDIR /tmp

# Download tomcat
RUN wget http://mirror.cogentco.com/pub/apache/tomcat/tomcat-7/v7.0.54/bin/apache-tomcat-7.0.54.tar.gz 
RUN tar -C /usr/local -xzf /tmp/apache-tomcat-7.*.tar.gz
RUN mv /usr/local/apache-tomcat-7.* /usr/local/tomcat

# set tomcat port to 8983
RUN sed -i s/8080/8983/g /usr/local/tomcat/conf/server.xml

#download solr
WORKDIR /tmp
RUN wget http://archive.apache.org/dist/lucene/solr/4.5.0/solr-4.5.0.tgz
RUN tar -xzf solr-4.5.0.tgz
# setup solr webapp libraries/conf
RUN cp solr-4.5.0/dist/solrj-lib/* /usr/local/tomcat/lib/
RUN cp solr-4.5.0/example/resources/log4j.properties /usr/local/tomcat/conf/
RUN cp solr-4.5.0/dist/solr-4.5.0.war /usr/local/tomcat/webapps/solr.war
RUN mkdir -p /usr/local/tomcat/conf/Catalina/localhost/
ADD conf/solr-tomcat-conf.xml /usr/local/tomcat/conf/Catalina/localhost/solr.xml

# add solr directory and copy example conf
RUN mkdir -p /usr/local/tomcat/solr
RUN cp -r solr-4.5.0/example/solr/collection1/conf /usr/local/tomcat/solr/

# solr core definitions
ADD conf/solr.xml /usr/local/tomcat/solr/solr.xml


# get drupal apachesolr module
RUN wget http://ftp.drupal.org/files/projects/apachesolr-7.x-1.x-dev.tar.gz
RUN gunzip /tmp/apachesolr-7.x-1.x-dev.tar.gz && tar -xvf /tmp/apachesolr-7.x-1.x-dev.tar

# copy over apachesolr module configuration
RUN rsync -av /tmp/apachesolr/solr-conf/solr-4.x/ /usr/local/tomcat/solr/conf/

# create drupal solr core config
RUN mkdir /usr/local/tomcat/solr/drupal
RUN cp -r /usr/local/tomcat/solr/conf /usr/local/tomcat/solr/drupal/

EXPOSE 22 8983

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
