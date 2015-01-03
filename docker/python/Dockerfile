FROM devops-base

# Install Python.
RUN \
  apt-get update && \
  apt-get install -y py  rm -rf /var/lib/apt/lists/*
thon python-dev python-pip python-virtualenv && \

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["bash"]