#!/bin/bash

docker pull lancachenet/monolithic
docker pull lancachenet/lancache-dns
docker pull nginx:1

set -e

docker build --pull --rm ./containers/ -t team-brh/game-server-base:debian -f ./containers/debian.base.Dockerfile
docker build --rm ./containers/hl2 -t team-brh/hl2:latest -f ./containers/hl2/hl2.Dockerfile
docker build --rm ./containers/tf2 -t team-brh/tf2:latest -f ./containers/tf2/tf2.Dockerfile
docker build --rm ./containers/css -t team-brh/css:latest -f ./containers/css/css.Dockerfile
docker build --rm ./containers/pz -t team-brh/pz:latest -f ./containers/pz/pz.Dockerfile
# Build failing right now
# docker build --rm ./containers/l4d2 -t team-brh/l4d2:latest -f ./containers/l4d2/l4d2.Dockerfile
docker build --rm ./containers/valheim -t team-brh/valheim:latest -f ./containers/valheim/valheim.Dockerfile
docker build --rm ./containers/factorio -t team-brh/factorio:latest -f ./containers/factorio/factorio.Dockerfile