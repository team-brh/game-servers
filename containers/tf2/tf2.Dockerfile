FROM team-brh/hl2:latest

# Link sourcemod directory
RUN mkdir -p $STEAM_GAME_DIR/tf/ \
    && ln -s /steam/addons $STEAM_GAME_DIR/tf/addons

# Add sm-json (DG dependency)
RUN mkdir /tmp/plugin \
    && cd /tmp/plugin \
    && curl -sL "https://github.com/clugg/sm-json/archive/refs/tags/v4.1.1.tar.gz" | tar -xz --strip-components 1 \
    && cp -R addons/sourcemod/* $SOURCEMOD_DIR/ \
    && rm -rf /tmp/plugin

# Load and build the dg plugin
RUN mkdir /tmp/plugin \
    && cd /tmp/plugin \
    && curl -sL "https://github.com/jesseryoung/drinkinggame/archive/b6f196222c50b532937aaf6bf8b340ef84d862a3.tar.gz" | tar -xz --strip-components 1 \
    && cd $SOURCEMOD_DIR/plugins \
    && $SOURCEMOD_DIR/scripting/spcomp /tmp/plugin/src/dgplugin.sp \
    && rm -rf /tmp/plugin

# Heavyboxing plugin
RUN mkdir /tmp/plugin \
    && cd /tmp/plugin \
    && curl -sL "https://github.com/jesseryoung/HeavyBoxing/archive/edb999d5cf4cb96d74b289880c422d3866069100.tar.gz" | tar -xz --strip-components 1 \
    && mkdir -p $STEAM_GAME_DIR/tf/sound/suddendeath/ \
    && cp hbm.mp3 $STEAM_GAME_DIR/tf/sound/suddendeath/ \
    && cd $SOURCEMOD_DIR/plugins \
    && $SOURCEMOD_DIR/scripting/spcomp /tmp/plugin/heavyboxing.sp \
    && rm -rf /tmp/plugin


ENV STEAM_APP_ID 232250

# Server startup entrypoint
ADD server_entrypoint.sh /steam/
USER root
RUN chmod +x /steam/server_entrypoint.sh
USER steam


# General game configs
ADD --chown=steam config/motd.txt $STEAM_GAME_DIR/tf/cfg/
ADD --chown=steam config/pure_server_whitelist.txt $STEAM_GAME_DIR/tf/cfg/
ADD --chown=steam config/server.cfg $STEAM_GAME_DIR/tf/cfg/
ADD --chown=steam config/mapcycle.txt $STEAM_GAME_DIR/tf/cfg/

# Sourcemod configs
ADD --chown=steam config/sourcemod.cfg $STEAM_GAME_DIR/tf/cfg/sourcemod/
ADD --chown=steam config/mapchooser.cfg $STEAM_GAME_DIR/tf/cfg/sourcemod/

ENTRYPOINT [ "/steam/steam_entrypoint.sh", "/steam/server_entrypoint.sh" ]
