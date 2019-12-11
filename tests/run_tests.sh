#!/bin/bash

DIR=$(pwd)

IMAGETAG=dotfiles
CONTAINERTAG=dotfiles-container

docker build -t $IMAGETAG -f tests/Dockerfile tests
docker run -v ${DIR}:/shared/my-dotfiles --rm --name $CONTAINERTAG -it $IMAGETAG
