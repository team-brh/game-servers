FROM team-brh/hl2:latest

# Link sourcmod directory
RUN mkdir -p $STEAM_GAME_DIR/tf/ \
    && ln -s /steam/addons $STEAM_GAME_DIR/tf/addons

# Load and build the dg plugin
RUN mkdir /tmp/plugin \
    && cd /tmp/plugin \
    && curl -sL "https://github.com/jesseryoung/drinkinggame/archive/2872f5311ec432c7f16f40d80a06f609f21fb7c6.tar.gz" | tar -xz --strip-components 1 \
    && mkdir -p $STEAM_GAME_DIR/tf/materials/dg/ \
    && cp *.vmt $STEAM_GAME_DIR/tf/materials/dg/ \
    && cp *.vtf $STEAM_GAME_DIR/tf/materials/dg/ \
    && cd $SOURCEMOD_DIR/plugins \
    && $SOURCEMOD_DIR/scripting/spcomp /tmp/plugin/src/dgplugin.sp \
    && rm -rf /tmp/plugin

# Overspray plugin
RUN mkdir /tmp/plugin \
    && cd /tmp/plugin \
    && curl -sL "https://github.com/team-brh/overspray/archive/cc7eefb22b88ae7f70de3e31e2787b58c86a14ae.tar.gz" | tar -xz --strip-components 1 \
    && cd $SOURCEMOD_DIR/plugins \
    && $SOURCEMOD_DIR/scripting/spcomp /tmp/plugin/overspray.sp \
    && rm -rf /tmp/plugin


# Heavyboxing plugin
RUN mkdir /tmp/plugin \
    && cd /tmp/plugin \
    && curl -sL "https://github.com/jesseryoung/HeavyBoxing/archive/a04dc4823110ff68b655282570414ae8936a2657.tar.gz" | tar -xz --strip-components 1 \
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
ADD --chown=steam config/maplists.cfg $SOURCEMOD_DIR/configs/
ADD --chown=steam config/mapchooser.cfg $STEAM_GAME_DIR/tf/cfg/sourcemod/
ADD --chown=steam config/sourcemod.cfg $STEAM_GAME_DIR/tf/cfg/sourcemod/



ENTRYPOINT [ "/steam/steam_entrypoint.sh", "/steam/server_entrypoint.sh" ]