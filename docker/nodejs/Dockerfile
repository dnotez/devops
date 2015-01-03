FROM devops-python

RUN apt-get update
RUN apt-get install -y curl && rm -rf /var/lib/apt/lists/*
RUN \
  mkdir -p /tmp/node && cd /tmp/node && \
  curl http://nodejs.org/dist/node-latest.tar.gz | tar xz --strip-components=1 && \
  ./configure && \
  CXX="g++ -Wno-unused-local-typedefs" make && \
  CXX="g++ -Wno-unused-local-typedefs" make install

RUN \
  cd /tmp && \
  rm -rf /tmp/node* && \
  npm install -g npm && \
  echo -e '\n# Node.js\nexport PATH="node_modules/.bin:$PATH"' >> /root/.bashrc

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["bash"]