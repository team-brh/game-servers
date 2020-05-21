FROM team-brh/hl2:latest

# Link sourcemod directory
RUN mkdir -p $STEAM_GAME_DIR/left4dead2/ \
    && ln -s /steam/addons $STEAM_GAME_DIR/left4dead2/addons

# Load and build plugin
RUN mkdir /tmp/plugin \
	&& cd /tmp/plugin \
	&& curl -L -o plugin.zip "https://github.com/lucaspenney/l4d2-versus-plus/archive/ede539bee0f5357df7e7455fac1ac088cb7af7bb.zip" \
	&& unzip plugin.zip \
	&& cd $SOURCEMOD_DIR/plugins \
	&& $SOURCEMOD_DIR/scripting/spcomp /tmp/plugin/l4d2-versus-plus-ede539bee0f5357df7e7455fac1ac088cb7af7bb/l4d2-versus-plus.sp \
	&& rm -rf /tmp/plugin

ENV STEAM_APP_ID 222860

# Server.cfg
ADD --chown=steam cfg/server.cfg $STEAM_GAME_DIR/left4dead2/cfg/
# Sourcemod configs
ADD --chown=steam cfg/sourcemod/*.cfg $STEAM_GAME_DIR/left4dead2/cfg/sourcemod/
# Sourcemod stuff
ADD --chown=steam addons/sourcemod/configs/* $STEAM_GAME_DIR/left4dead2/addons/sourcemod/configs/
ADD --chown=steam addons/sourcemod/gamedata/* $STEAM_GAME_DIR/left4dead2/addons/sourcemod/gamedata/
ADD --chown=steam addons/sourcemod/plugins/* $STEAM_GAME_DIR/left4dead2/addons/sourcemod/plugins/

# Server startup entrypoint
ADD server_entrypoint.sh /steam/
USER root
RUN chmod +x /steam/server_entrypoint.sh
USER steam


ENTRYPOINT [ "/steam/steam_entrypoint.sh", "/steam/server_entrypoint.sh" ]
