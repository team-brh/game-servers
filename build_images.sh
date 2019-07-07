#!/bin/bash

docker build --rm ./containers/ -t team-brh/game-server-base:latest -f ./containers/base.Dockerfile
docker build --rm ./containers/hl2 -t team-brh/hl2:latest -f ./containers/hl2/hl2.Dockerfile
docker build --rm ./containers/tf2 -t team-brh/tf2:latest -f ./containers/tf2/tf2.Dockerfile
docker build --rm ./containers/css -t team-brh/css:latest -f ./containers/css/css.Dockerfile
docker build --rm ./containers/mordhau -t team-brh/game-server-base:latest -f ./containers/mordhau.mordhau.Dockerfile