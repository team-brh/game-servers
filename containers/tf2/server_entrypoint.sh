#!/bin/bash

touch $STEAM_GAME_DIR/console.log

$STEAM_GAME_DIR/srcds_run \
    -game tf \
    -debug \
    -consolelog $STEAM_GAME_DIR/console.log \
    +ip 0.0.0.0 \
    +sv_pure 1 \
    +mapcyclefile mapcycle.txt \
    +map koth_nucleus \
    +maxplayers 32 &

tail -F $STEAM_GAME_DIR/console.log