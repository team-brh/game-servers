Team-BRH - Open Source Game Server Hosting
===========================================
This repository is used to build the games servers hosted by the Bar Room Heroes community.

As of the latest version the following servers are hosted using this repository:
<a href="https://www.gametracker.com/server_info/69.162.82.213:27015/" target="_blank"><img src="https://cache.gametracker.com/server_info/69.162.82.213:27015/b_350_20_692108_381007_ffffff_000000.png" border="0" width="350" height="20" alt=""/></a>

<a href="https://www.gametracker.com/server_info/69.162.82.211:27015/" target="_blank"><img src="https://cache.gametracker.com/server_info/69.162.82.211:27015/b_350_20_692108_381007_ffffff_000000.png" border="0" width="350" height="20" alt=""/></a>


Using This Repository
=====================
Requirements
------------
- Docker CE
- Docker Compose

Building
------------
Run `build_images.cmd` (Windows) or `build_images.sh` (Linux/Mac) to build all images in the repository.

Running
------------
Run `run_dev.cmd` (Windows) or `run_dev.sh` (Linux/Mac) to run the servers locally. It will take a bit for the servers to come up as they will need to download the latest versions of the game. After the first one Monolithic caches the downloads startup should be faster.

After the server is up you should be able to connect via the console by typing `connect <network address>` in the console of the game.

> **Note:** `<network address>` is not `localhost` or `127.0.0.1` it is your computers local network address.

Components
==========
docker-compose.yml
---------------------
Primary definition for all the services that run on the server.

docker-compose.dev.yml
----------------------
Development overrides and ports for running the servers locally. This is also has some security features of docker disabled to make debugging easier. Running `run_dev.cmd` (`run_dev.sh`) uses this override.

docker-compose.prod.yml
-----------------------
Production overrides for IP addresses and ports. This binds the services to the actual IP addresses on the Team-BRH game server. Running `run_prod.cmd` (`run_prod.sh`) uses this override.

[steamcache/monolithic](https://github.com/steamcache/monolithic)
---------------------
Monolithic is a docker container that provides game download caching for a downloads from many service providers such as Steam, Origin and Battle.net.

When a game server container starts it needs to download the server itself (the server isn't included as part of the docker image). To speed up restarts, this image is used to prevent unnecessary 8+ GB downloads from Steam.

[steamcache/steamcache-dns](https://github.com/steamcache/steamcache-dns)
----------------------------
This is a DNS that will transparently take over requests for resources Monolithic can serve. 

tf2
------------
This container hosts the TF2 game server for the community.

css
-------------
This container hosts the Counter-Strike: Source game server for the community.