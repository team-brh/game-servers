FROM team-brh/game-server-base:latest

# Copy down Metamod/Sourcemod
RUN mkdir -p $STEAM_GAME_DIR/tf/ \
    && cd $STEAM_GAME_DIR/tf/ \
    && curl -sL "https://www.sourcemm.net/latest.php?os=linux&version=1.10" | tar -xz \
    && curl -sL "http://sourcemod.net/latest.php?os=linux&version=1.10" | tar -xz 

# Grab accelerator (crash dump analyzer)
RUN curl -sL -o /tmp/accelerator.zip https://builds.limetech.io/files/accelerator-2.4.3-git127-b302f00-linux.zip  \
    && unzip -qq /tmp/accelerator.zip -d $STEAM_GAME_DIR/tf/ \
    && rm /tmp/accelerator.zip

ENV SOURCEMOD_DIR $STEAM_GAME_DIR/tf/addons/sourcemod/

# Load and build the dg plugin
RUN mkdir /tmp/plugin \
    && cd /tmp/plugin \
    && curl -sL "https://github.com/jesseryoung/drinkinggame/archive/master.tar.gz" | tar -xz --strip-components 1 \
    && mkdir -p $STEAM_GAME_DIR/tf/materials/dg/ \
    && cp *.vmt $STEAM_GAME_DIR/tf/materials/dg/ \
    && cp *.vtf $STEAM_GAME_DIR/tf/materials/dg/ \
    && cd $SOURCEMOD_DIR/plugins \
    && $SOURCEMOD_DIR/scripting/spcomp /tmp/plugin/src/dgplugin.sp \
    && rm -rf /tmp/plugin

# Overspray plugin
RUN curl -sL -o /tmp/overspray.sp https://raw.githubusercontent.com/team-brh/overspray/master/overspray.sp \
    && cd $SOURCEMOD_DIR/plugins \
    && $SOURCEMOD_DIR/scripting/spcomp /tmp/overspray.sp \
    && rm /tmp/overspray.sp


# Heavyboxing plugin
RUN curl -sL -o /tmp/heavyboxing.sp https://raw.githubusercontent.com/jesseryoung/HeavyBoxing/master/heavyboxing.sp \
    && mkdir -p $STEAM_GAME_DIR/tf/sound/suddendeath/ \
    && curl -sL -o $STEAM_GAME_DIR/tf/sound/suddendeath/hbm.mp3 https://github.com/jesseryoung/HeavyBoxing/raw/master/hbm.mp3 \
    && cd $SOURCEMOD_DIR/plugins \
    && $SOURCEMOD_DIR/scripting/spcomp /tmp/heavyboxing.sp \
    && rm /tmp/heavyboxing.sp

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