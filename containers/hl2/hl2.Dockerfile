FROM team-brh/game-server-base:latest

RUN mkdir -p /steam/addons/

ENV SOURCEMOD_DIR /steam/addons/sourcemod

# Copy down Metamod/Sourcemod
RUN cd /steam/addons/ \
    && curl -sL "https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git970-linux.tar.gz" | tar -xz addons --strip-components 1 \
    && curl -sL "https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6394-linux.tar.gz" | tar -xz addons --strip-components 1

# Grab accelerator (crash dump analyzer)
RUN curl -sL -o /tmp/accelerator.zip https://builds.limetech.io/files/accelerator-2.4.3-git127-b302f00-linux.zip  \
    && unzip -qq /tmp/accelerator.zip -d $SOURCEMOD_DIR \
    && rm /tmp/accelerator.zip


# Copy disabled plugins
RUN mv $SOURCEMOD_DIR/plugins/disabled/mapchooser.smx $SOURCEMOD_DIR/plugins/ \
    && mv $SOURCEMOD_DIR/plugins/disabled/rockthevote.smx $SOURCEMOD_DIR/plugins/ \
    && mv $SOURCEMOD_DIR/plugins/disabled/randomcycle.smx $SOURCEMOD_DIR/plugins/ \
    && mv $SOURCEMOD_DIR/plugins/disabled/nominations.smx $SOURCEMOD_DIR/plugins/

# Sourcemod configs
ADD --chown=steam config/admin_groups.cfg $SOURCEMOD_DIR/configs/
ADD --chown=steam config/admins_simple.ini $SOURCEMOD_DIR/configs/
ADD --chown=steam config/core.cfg $SOURCEMOD_DIR/configs/