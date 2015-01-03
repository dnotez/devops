#!/bin/bash
REPO=devops
VERSION="0.1"
BUILD_CMD="docker build -t"

usage() {
cat << EOF
usage: $0 options
Build docker images
OPTIONS:
    -h  show usage help
    -b  build base images
    -s  build specific image with name :name (name must be a folder in current folder containing Docker file)
    -l  list all images
    -t  run a continer in bash (will be removed after exit)
    -r  repository name (default ${REPO})
EOF
}

buildAndTag() {
    NAME=$1
    FILE=$2
    echo "Building: $NAME, path: $FILE"
    ${BUILD_CMD} "${REPO}-${NAME}" ${FILE}
}

base() {
    echo "Building base image ..."
    buildAndTag "base" base
    buildAndTag "jdk8" jdk8
    #buildAndTag "python" python
    #buildAndTag "nodejs" nodejs
    buildAndTag "jenkins" jenkins
    list
}

list() {
    docker images | grep "${REPO}-"
}

run() {
    echo "Running $1 ..."
    docker run -ti --rm  ${REPO}-$1 /bin/bash
}

while getopts "blhr:t:s:" OPTION
do
    case ${OPTION} in
        h)
            usage
            exit 1
            ;;
        b)
            base
            exit 0
            ;;
        s)
            buildAndTag ${OPTARG} ${OPTARG}
            exit 0
            ;;
        l)
            list
            exit 0
            ;;
        t)
            run ${OPTARG}
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