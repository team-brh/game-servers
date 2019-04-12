FROM team-brh/hl2:latest

# Link sourcmod directory
RUN mkdir -p $STEAM_GAME_DIR/cstrike/ \
    && ln -s /steam/addons $STEAM_GAME_DIR/cstrike/addons

ENV STEAM_APP_ID 232330

# Server startup entrypoint
ADD server_entrypoint.sh /steam/
USER root
RUN chmod +x /steam/server_entrypoint.sh
USER steam


# General game configs
ADD --chown=steam config/server.cfg $STEAM_GAME_DIR/cstrike/cfg/
ADD --chown=steam config/motd.txt $STEAM_GAME_DIR/cstrike/cfg/
# ADD config/mapcycle.txt $STEAM_GAME_DIR/tf/cfg/

# Sourcemod configs
ADD --chown=steam config/sourcemod.cfg $STEAM_GAME_DIR/cstrike/cfg/sourcemod/
# ADD config/maplists.cfg $SOURCEMOD_DIR/configs/
# ADD config/mapchooser.cfg $STEAM_GAME_DIR/tf/cfg/sourcemod/


ENTRYPOINT [ "/steam/steam_entrypoint.sh", "/steam/server_entrypoint.sh" ]