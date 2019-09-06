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
RUN curl -sL -o /tmp/plugin.zip "https://forums.alliedmods.net/attachment.php?attachmentid=32686&d=1224250281"  \
    && unzip -qq /tmp/plugin.zip -d $STEAM_GAME_DIR/cstrike \
    && rm /tmp/plugin.zip


# Weapon restrict
RUN curl -sL -o /tmp/plugin.zip "https://forums.alliedmods.net/attachment.php?attachmentid=162251&d=1492626443"  \
    && unzip -qq /tmp/plugin.zip -d /tmp/ \
    && cp -R /tmp/weapon-restrict/addons/* $STEAM_GAME_DIR/cstrike/addons/ \
    && rm /tmp/plugin.zip \
    && rm -rf /tmp/weapon-restrict

# Extra Cash
RUN curl -sL -o $SOURCEMOD_DIR/plugins/extra_cash.smx "http://www.sourcemod.net/vbcompiler.php?file_id=18836"
# Quick Defuse
RUN curl -sL -o $SOURCEMOD_DIR/plugins/QuickDefuse.smx "http://www.sourcemod.net/vbcompiler.php?file_id=19309"
# simpletk
RUN curl -sL -o $SOURCEMOD_DIR/plugins/simpletk.smx "http://www.sourcemod.net/vbcompiler.php?file_id=86692"
RUN curl -sL -o $SOURCEMOD_DIR/translations/simpletk.phrases.txt "https://forums.alliedmods.net/attachment.php?attachmentid=86654&d=1306426815"



# General game configs
ADD --chown=steam config/server.cfg $STEAM_GAME_DIR/cstrike/cfg/
ADD --chown=steam config/motd.txt $STEAM_GAME_DIR/cstrike/cfg/
ADD --chown=steam config/pure_server_whitelist.txt $STEAM_GAME_DIR/cstrike/cfg/
ADD --chown=steam config/mapcycle.txt $STEAM_GAME_DIR/tf/cfg/

# Sourcemod configs
ADD --chown=steam config/sourcemod.cfg $STEAM_GAME_DIR/cstrike/cfg/sourcemod/
ADD --chown=steam config/knifefight.cfg $STEAM_GAME_DIR/cstrike/cfg/sourcemod/
ADD --chown=steam config/weapon_restrict.cfg $STEAM_GAME_DIR/cstrike/cfg/sourcemod/
ADD --chown=steam config/plugin.simpletk.cfg $STEAM_GAME_DIR/cstrike/cfg/sourcemod/


ENTRYPOINT [ "/steam/steam_entrypoint.sh", "/steam/server_entrypoint.sh" ]