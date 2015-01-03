FROM devops-jdk8

RUN apt-get update

RUN apt-get install -y wget git curl zip bzip2 libfreetype6 libfontconfig make python python-dev python-pip ruby-full \
 && rm -rf /var/lib/apt/lists/*

#building node
RUN mkdir -p /tmp/node && \
    cd /tmp/node && \
    curl http://nodejs.org/dist/node-latest.tar.gz | tar xz --strip-components=1 && \
    ./configure && \
    CXX="g++ -Wno-unused-local-typedefs" make && \
    CXX="g++ -Wno-unused-local-typedefs" make install

RUN \
  cd /tmp && \
  rm -rf /tmp/node* && \
  npm install -g npm && \
  echo -e '\n# Node.js\nexport PATH="node_modules/.bin:$PATH"' >> /etc/bash.bashrc

RUN \
   npm install -g gulp && \
   npm install -g yo && \
   npm install -g bower && \
   npm install -g grunt-cli
   npm install -g phantomjs

#building phantomjs
ENV PHANTOMJS_VERSION 1.9.8

RUN curl -SLO "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2" \
	&& tar -xjf "phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2" -C /usr/local --strip-components=1 \
	&& rm "phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2"

# install compass
RUN gem install --no-rdoc --no-ri compass

ENV JENKINS_VERSION 1.595
ENV JENKINS_HOME /var/jenkins_home

RUN mkdir /usr/share/jenkins/

RUN useradd -d "$JENKINS_HOME" -u 1000 -m -s /bin/bash jenkins
#RUN useradd -d /home/jenkins -m -s /bin/bash jenkins

VOLUME /var/jenkins_home

ADD batch-install-jenkins-plugins.sh /usr/local/bin/batch-install-jenkins-plugins.sh
ADD plugins.list /tmp/plugins.list
ADD init.groovy /tmp/WEB-INF/init.groovy.d/tcp-slave-agent-port.groovy

# Downloading custom plugins and jenkins. Putting custom plugins into jenkins.war
RUN mkdir -p /tmp/WEB-INF/plugins \
 && batch-install-jenkins-plugins.sh -p /tmp/plugins.list -d /tmp/WEB-INF/plugins \
 && curl -L http://updates.jenkins-ci.org/download/war/$JENKINS_VERSION/jenkins.war -o /usr/share/jenkins/jenkins.war \
 && cd /tmp \
 && zip -g /usr/share/jenkins/jenkins.war WEB-INF/*/* \
 && rm -rf /tmp/WEB-INF

# for main web interface:
EXPOSE 8080

# will be used by attached slave agents:
EXPOSE 50000

ADD jenkins.sh /usr/local/bin/jenkins.sh

ENTRYPOINT ["/usr/local/bin/jenkins.sh"]

RUN locale-gen en_GB.UTF-8
ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB:en
ENV LC_ALL en_GB.UTF-8

USER jenkins 
