FROM ubuntu:12.04
MAINTAINER bwheeler@giantrabbit.com
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qy update && apt-get -y upgrade

# install and add configuration to jetty
RUN apt-get -y install default-jdk unzip wget
RUN cd /opt && \
  wget http://archive.apache.org/dist/lucene/solr/3.6.2/apache-solr-3.6.2.zip && \
  unzip apache-solr-3.6.2.zip && mv apache-solr-3.6.2 solr && \
  rm apache-solr-3.6.2.zip

# copy solr example to instance
RUN cp -R /opt/solr/example/ /opt/solr/instance/

# copy drupal instance configuration to drupal core 

ADD conf/apachesolr/solr-conf/solr-3.x/* /opt/solr/instance/drupal/conf/

#copy solr core xml to instance
ADD conf/solr.xml /opt/solr/instance/solr/solr.xml

EXPOSE 8983
WORKDIR /opt/solr/instance
CMD ["java","-jar", "start.jar"]
