FROM team-brh/game-server-base:latest

# Copy down Metamod/Sourcemod
RUN mkdir -p $STEAM_GAME_DIR/tf/ \
    && cd $STEAM_GAME_DIR/tf/ \
    && curl -sL "https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git970-linux.tar.gz" | tar -xz \
    && curl -sL "https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6394-linux.tar.gz" | tar -xz 

# Grab accelerator (crash dump analyzer)
RUN curl -sL -o /tmp/accelerator.zip https://builds.limetech.io/files/accelerator-2.4.3-git127-b302f00-linux.zip  \
    && unzip -qq /tmp/accelerator.zip -d $STEAM_GAME_DIR/tf/ \
    && rm /tmp/accelerator.zip

ENV SOURCEMOD_DIR $STEAM_GAME_DIR/tf/addons/sourcemod/

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


# Copy disabled plugins
RUN mv $SOURCEMOD_DIR/plugins/disabled/mapchooser.smx $SOURCEMOD_DIR/plugins/ \
    && mv $SOURCEMOD_DIR/plugins/disabled/rockthevote.smx $SOURCEMOD_DIR/plugins/ \
    && mv $SOURCEMOD_DIR/plugins/disabled/randomcycle.smx $SOURCEMOD_DIR/plugins/ \
    && mv $SOURCEMOD_DIR/plugins/disabled/nominations.smx $SOURCEMOD_DIR/plugins/


ENV STEAM_APP_ID 232250
ADD server_entrypoint.sh /steam/
USER root
RUN chmod +x /steam/server_entrypoint.sh
USER steam


# General game configs
ADD config/motd.txt $STEAM_GAME_DIR/tf/cfg/
ADD config/pure_server_whitelist.txt $STEAM_GAME_DIR/tf/cfg/
ADD config/server.cfg $STEAM_GAME_DIR/tf/cfg/
ADD config/mapcycle.txt $STEAM_GAME_DIR/tf/cfg/

# Sourcemod configs
ADD config/admin_groups.cfg $SOURCEMOD_DIR/configs/
ADD config/admins_simple.ini $SOURCEMOD_DIR/configs/
ADD config/maplists.cfg $SOURCEMOD_DIR/configs/
ADD config/core.cfg $SOURCEMOD_DIR/configs/
ADD config/sourcemod.cfg $STEAM_GAME_DIR/tf/cfg/sourcemod/
ADD config/mapchooser.cfg $STEAM_GAME_DIR/tf/cfg/sourcemod/




ENTRYPOINT [ "/steam/steam_entrypoint.sh", "/steam/server_entrypoint.sh" ]