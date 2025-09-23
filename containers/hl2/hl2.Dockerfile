FROM team-brh/game-server-base:debian

RUN mkdir -p /steam/addons/

ENV SOURCEMOD_DIR /steam/addons/sourcemod

# Copy down Metamod/Sourcemod
RUN cd /steam/addons/ \
    && curl -sL "https://mms.alliedmods.net/mmsdrop/1.12/mmsource-1.12.0-git1219-linux.tar.gz" | tar -xz addons --strip-components 1 \
    && curl -sL "https://sm.alliedmods.net/smdrop/1.12/sourcemod-1.12.0-git7210-linux.tar.gz" | tar -xz addons --strip-components 1 \
    # Metamod added support for 64bit servers, but will break 32bit servers if metamod_x64.vdf is in the addons folder
    && rm /steam/addons/metamod_x64.vdf

# Grab accelerator (crash dump analyzer)
RUN curl -sL -o /tmp/accelerator.zip https://builds.limetech.io/files/accelerator-2.5.0-git138-cd575aa-linux.zip  \
    && unzip -qq /tmp/accelerator.zip -d /steam/ \
    && rm /tmp/accelerator.zip


# Move disabled plugins
RUN mv $SOURCEMOD_DIR/plugins/disabled/mapchooser.smx $SOURCEMOD_DIR/plugins/ \
    && mv $SOURCEMOD_DIR/plugins/disabled/rockthevote.smx $SOURCEMOD_DIR/plugins/ \
    && mv $SOURCEMOD_DIR/plugins/disabled/randomcycle.smx $SOURCEMOD_DIR/plugins/ \
    && mv $SOURCEMOD_DIR/plugins/disabled/nominations.smx $SOURCEMOD_DIR/plugins/

# Add shared plugins
# Download broken, fix later
# Spraytrace
# RUN mkdir /tmp/plugin \
#    && cd /tmp/plugin \
#    && curl -sL -o plugin.zip "https://forums.alliedmods.net/attachment.php?attachmentid=85509&d=1304342097" \
#    && unzip plugin.zip \
#    && cd $SOURCEMOD_DIR/plugins \
#    && $SOURCEMOD_DIR/scripting/spcomp /tmp/plugin/*.sp \
#    && cp /tmp/plugin/*.phrases.txt $SOURCEMOD_DIR/translations/ \
#    && rm -rf /tmp/plugin

# Overspray plugin
RUN mkdir /tmp/plugin \
    && cd /tmp/plugin \
    && curl -sL "https://github.com/team-brh/overspray/archive/cc7eefb22b88ae7f70de3e31e2787b58c86a14ae.tar.gz" | tar -xz --strip-components 1 \
    && cd $SOURCEMOD_DIR/plugins \
    && $SOURCEMOD_DIR/scripting/spcomp /tmp/plugin/*.sp \
    && rm -rf /tmp/plugin

# Sourcemod configs
ADD --chown=steam config/admin_groups.cfg $SOURCEMOD_DIR/configs/
ADD --chown=steam config/admins_simple.ini $SOURCEMOD_DIR/configs/
ADD --chown=steam config/core.cfg $SOURCEMOD_DIR/configs/

ADD --chown=steam config/maplists.cfg $SOURCEMOD_DIR/configs/
