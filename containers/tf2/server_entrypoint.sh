#!/bin/bash

$STEAM_GAME_DIR/srcds_run \
    -game tf \
    -debug \
    +ip 0.0.0.0 \
    +sv_pure 1 \
    +mapcyclefile mapcycle.txt \
    +map koth_viaduct_event \
    +maxplayers 32
