#!/bin/bash

# Replace environment variables in steam_update.txt
envsubst < /steam/steam_app_update.txt > /steam/game_update.txt

# Launch update to install the steam game
$STEAMCMD_DIR/steamcmd.sh -tcp +runscript /steam/game_update.txt

# Create/cleanup folder for container console
rm -rf /console/$CONTAINER_NAME
mkdir /console/$CONTAINER_NAME

# Create stdin pipe and prime it
mkfifo /console/$CONTAINER_NAME/console.in
sleep infinity > /console/$CONTAINER_NAME/console.in &

# Execute passed in command line tricking the executable into thinking it has an actual tty
script \
    --flush \
    --quiet \
    --command "$@" \
    /console/$CONTAINER_NAME/console.out \
    < /console/$CONTAINER_NAME/console.in