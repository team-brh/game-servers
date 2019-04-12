#!/bin/bash

# Replace environment variables in steam_update.txt
envsubst < /steam/steam_app_update.txt > /steam/game_update.txt

# Launch update to install the steam game
$STEAMCMD_DIR/steamcmd.sh +runscript /steam/game_update.txt

# Execute passed in command line
"$@"