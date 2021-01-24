#!/bin/bash

# copy files into maps file
cp -r /fastdownload/cstrike $STEAM_GAME_DIR/


$STEAM_GAME_DIR/srcds_run \
    -game cstrike \
    -debug \
    +ip 0.0.0.0 \
    +sv_pure 1 \
    +map de_dust \
    +maxplayers 24 \
    +fps_max 500 