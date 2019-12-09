#!/bin/bash

IMAGETAG=dotfiles
CONTAINERTAG=dotfiles-container

docker build -t $IMAGETAG -f tests/Dockerfile tests
docker run -v /home/adam/Projects/my-dotfiles:/shared/my-dotfiles --rm --name $CONTAINERTAG -it $IMAGETAG
