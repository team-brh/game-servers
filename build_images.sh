#!/bin/bash

docker build --rm ./containers/ -t team-brh/game-server-base:centos -f ./containers/centos.base.Dockerfile
docker build --rm ./containers/ -t team-brh/game-server-base:debian -f ./containers/debian.base.Dockerfile
docker build --rm ./containers/hl2 -t team-brh/hl2:latest -f ./containers/hl2/hl2.Dockerfile
docker build --rm ./containers/tf2 -t team-brh/tf2:latest -f ./containers/tf2/tf2.Dockerfile
docker build --rm ./containers/css -t team-brh/css:latest -f ./containers/css/css.Dockerfile
docker build --rm ./containers/pz -t team-brh/pz:latest -f ./containers/pz/pz.Dockerfile