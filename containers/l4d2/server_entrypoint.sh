#!/bin/bash

touch $STEAM_GAME_DIR/console.log

# copy addons into addons folder
cp -r /fastdownload/l4d2/. $STEAM_GAME_DIR/left4dead2/addons/

# copy addonconfig as srcds install will overwrite
cp $STEAM_GAME_DIR/addonconfig.cfg $STEAM_GAME_DIR/left4dead2/cfg/addonconfig.cfg

# Delete plugins that the hl2 dockerfile has rudely installed
rm $STEAM_GAME_DIR/left4dead2/addons/sourcemod/plugins/nextmap.smx
rm $STEAM_GAME_DIR/left4dead2/addons/sourcemod/plugins/mapchooser.smx
rm $STEAM_GAME_DIR/left4dead2/addons/sourcemod/plugins/rockthevote.smx
rm $STEAM_GAME_DIR/left4dead2/addons/sourcemod/plugins/nominations.smx
rm $STEAM_GAME_DIR/left4dead2/addons/sourcemod/plugins/overspray.smx
rm $STEAM_GAME_DIR/left4dead2/addons/sourcemod/plugins/randomcycle.smx
rm $STEAM_GAME_DIR/left4dead2/addons/sourcemod/plugins/reservedslots.smx
rm $STEAM_GAME_DIR/left4dead2/addons/sourcemod/plugins/spraytrace.smx

$STEAM_GAME_DIR/srcds_run \
    -game left4dead2 \
    +ip 0.0.0.0 \
    +maxplayers 8 \
    +map c2m1_highway &

tail -F $STEAM_GAME_DIR/console.log
