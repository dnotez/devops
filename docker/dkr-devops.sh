#!/bin/bash
REGISTRY=localhost:5000

REPO=devops

if [ -z ${JENKINS_HOME} ]; then
    JENKINS_HOME=`pwd`/jenkins-home
fi

usage() {
cat << EOF
usage: $0 options
Run docker containers
OPTIONS:
    -h  show usage help
    -a  run all container
    -l  list ${REPO} containers
    -j  run jenkins container
    -e  enter running container
    -g  show container logs
    -s  start all containers
    -r  registry address (default ${REGISTRY})
EOF
}

jenkins() {
    docker run -t -d --name jenkins --net host -p 8080:8080  -p 50000:50000 -v ${JENKINS_HOME}:/var/jenkins_home ${REPO}-jenkins
}

list() {
    docker ps -a | grep "${REPO}-"
}

logs() {
    ID=$(docker ps -a | grep ${REPO}-$1 | awk '{print $1}')
    docker logs -f ${ID}
}

enter(){
    ID=$(docker ps -a | grep ${REPO}-$1 | awk '{print $1}')
    docker exec -it ${ID} bash
}

startAll() {
    docker start jenkins
    list
}

while getopts "bljhsr:g:e:" OPTION
do
    case ${OPTION} in
        h)
            usage
            exit 1
            ;;
        l)
            list
            exit 0
            ;;
        s)
            startAll
            exit 0
            ;;
        j)
            jenkins
            exit 0
            ;;
        g)
            logs ${OPTARG}
            exit 0
            ;;
        e)
            enter ${OPTARG}
            exit 0
            ;;
    esac
done

if [[ -z ${NAME} ]]
then
    usage
    exit 1
fi

IFS=', ' read -a excludes << "$EXCLUDE"