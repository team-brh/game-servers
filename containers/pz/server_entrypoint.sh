#!/bin/bash 

echo "In server_entrypoint.sh"

$STEAM_GAME_DIR/start-server.sh -tcp -adminpassword password
