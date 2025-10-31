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

# Knife fight plugin
ADD --chown=steam plugins/knifefight.tar $STEAM_GAME_DIR/cstrike

# Weapon restrict
ADD --chown=steam plugins/weapon-restrict.tar $STEAM_GAME_DIR/cstrike

# Extra Cash
RUN curl -sL -o $SOURCEMOD_DIR/plugins/extra_cash.smx "http://www.sourcemod.net/vbcompiler.php?file_id=18836"
# Quick Defuse
RUN curl -sL -o $SOURCEMOD_DIR/plugins/QuickDefuse.smx "http://www.sourcemod.net/vbcompiler.php?file_id=19309"

# simpletk
ADD --chown=steam plugins/simpletk.tar $SOURCEMOD_DIR
RUN cd $SOURCEMOD_DIR/plugins \
   && $SOURCEMOD_DIR/scripting/spcomp $SOURCEMOD_DIR/scripting/simpletk.sp


# General game configs
ADD --chown=steam config/server.cfg $STEAM_GAME_DIR/cstrike/cfg/
ADD --chown=steam config/motd.txt $STEAM_GAME_DIR/cstrike/cfg/
ADD --chown=steam config/pure_server_whitelist.txt $STEAM_GAME_DIR/cstrike/cfg/
ADD --chown=steam config/mapcycle.txt $STEAM_GAME_DIR/cstrike/cfg/

# Sourcemod configs
ADD --chown=steam config/sourcemod.cfg $STEAM_GAME_DIR/cstrike/cfg/sourcemod/
ADD --chown=steam config/knifefight.cfg $STEAM_GAME_DIR/cstrike/cfg/sourcemod/
ADD --chown=steam config/weapon_restrict.cfg $STEAM_GAME_DIR/cstrike/cfg/sourcemod/
ADD --chown=steam config/plugin.simpletk.cfg $STEAM_GAME_DIR/cstrike/cfg/sourcemod/
ADD --chown=steam config/mapchooser.cfg $STEAM_GAME_DIR/cstrike/cfg/sourcemod/


ENTRYPOINT [ "/steam/steam_entrypoint.sh", "/steam/server_entrypoint.sh" ]