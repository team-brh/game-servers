docker build .\containers\ -t team-brh/game-server-base:latest -f .\containers\base.Dockerfile
docker build .\containers\tf2 -t team-brh/tf2:latest -f .\containers\tf2\tf2.Dockerfile