#!/bin/bash

$STEAM_GAME_DIR/srcds_run \
    -game tf \
    -autoupdate \
    -steam_dir /steam/ \
    -steamcmd_script /steam/game_update.txt \
    +ip 0.0.0.0 \
    +sv_pure 1 \
    +mapcyclefile mapcycle.txt \
    +map koth_nucleus \
    +maxplayers 32