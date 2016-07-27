#!/bin/bash

# include config
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/../config/docker-config.sh

# stop all running containers
sudo docker stop ${CONTAINER_WEB} ${CONTAINER_MEM}

# delete all containers
sudo docker rm ${CONTAINER_WEB} ${CONTAINER_MEM}

# delete all images
sudo docker rmi ${CONTAINER_WEB_IMAGE} ${CONTAINER_MEM_IMAGE}