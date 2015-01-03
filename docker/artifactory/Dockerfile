# Artifactory
FROM ubuntu:latest
MAINTAINER Mamad Asgari "mammad.asgari@gmail.com"

#apt-cache-ng is buggy! install squid-deb-proxy on host
ENV DOCKER_HOST 192.168.0.65
RUN mkdir -p /etc/apt/apt.conf.d/ && \
        echo "Acquire::http { Proxy \"http://${DOCKER_HOST}:3142\"; };" >> /etc/apt/apt.conf.d/01proxy

# This is needed for openjdk-7-jre-headless. Universe is for community-maintained software
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y openjdk-7-jre-headless unzip

ADD http://dl.bintray.com/content/jfrog/artifactory/artifactory-3.4.0.zip?direct artifactory.zip
RUN unzip artifactory.zip && rm -f artifactory.zip

# This is needed to run on t1.micro, but shouldn't matter anywhere else
RUN sed -i -e 's/Xmx2g/Xmx512m/g' artifactory-*/bin/artifactory.default

# Expose the default endpoint
EXPOSE 8081

# Run the embedded tomcat container
ENTRYPOINT artifactory-*/bin/artifactory.sh
