#!/bin/bash

touch $STEAM_GAME_DIR/console.log

$STEAM_GAME_DIR/srcds_run \
    -game tf \
    -debug \
    -autoupdate \
    -steam_dir $STEAMCMD_DIR/ \
    -steamcmd_script /steam/game_update.txt \
    -consolelog $STEAM_GAME_DIR/console.log \
    +ip $IP_ADDRESS \
    +sv_pure 1 \
    +mapcyclefile mapcycle.txt \
    +map koth_nucleus \
    +maxplayers 32 &

tail -F $STEAM_GAME_DIR/console.log