REPO=artifactory
PROXY=http://192.168.2.2:3142/
.DEFAULT: build
.PHONY: build push all

all: build

build:
	docker build --rm -t $(REPO) .
push:
	docker push $(REPO)

run:
	docker run -d --name $(REPO) -h $(REPO) -t -p 8081:8081 $(REPO)

bash:
	docker run -t -i --rm  $(REPO) /bin/bash