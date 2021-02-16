#!/bin/bash

export LD_LIBRARY_PATH=$STEAM_GAME_DIR/linux64:$LD_LIBRARY_PATH
export SteamAppId=892970


echo "Starting server PRESS CTRL-C to exit"

# Tip: Make a local copy of this script to avoid it being overwritten by steam.
# NOTE: Minimum password length is 5 characters & Password cant be in the server name.
# NOTE: You need to make sure the ports 2456-2458 is being forwarded to your server through your local router & firewall.
$STEAM_GAME_DIR/valheim_server.x86_64 -name "The Bar Room" -port 2456 -world "Dedicated" -password "bringbeer" -savedir $VALHEIM_SAVE_DIR -public 1
