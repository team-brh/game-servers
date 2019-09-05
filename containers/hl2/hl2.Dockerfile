FROM team-brh/game-server-base:centos

RUN mkdir -p /steam/addons/

ENV SOURCEMOD_DIR /steam/addons/sourcemod

# Copy down Metamod/Sourcemod
RUN cd /steam/addons/ \
    && curl -sL "https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git970-linux.tar.gz" | tar -xz addons --strip-components 1 \
    && curl -sL "https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6403-linux.tar.gz" | tar -xz addons --strip-components 1

# Grab accelerator (crash dump analyzer)
RUN curl -sL -o /tmp/accelerator.zip https://builds.limetech.io/files/accelerator-2.4.3-git127-b302f00-linux.zip  \
    && unzip -qq /tmp/accelerator.zip -d /steam/ \
    && rm /tmp/accelerator.zip


# Move disabled plugins
RUN mv $SOURCEMOD_DIR/plugins/disabled/mapchooser.smx $SOURCEMOD_DIR/plugins/ \
    && mv $SOURCEMOD_DIR/plugins/disabled/rockthevote.smx $SOURCEMOD_DIR/plugins/ \
    && mv $SOURCEMOD_DIR/plugins/disabled/randomcycle.smx $SOURCEMOD_DIR/plugins/ \
    && mv $SOURCEMOD_DIR/plugins/disabled/nominations.smx $SOURCEMOD_DIR/plugins/

# Add shared plugins
# Spraytrace
RUN curl -sL -o $SOURCEMOD_DIR/plugins/spraytrace.smx "http://www.sourcemod.net/vbcompiler.php?file_id=85506"

# Overspray plugin
RUN mkdir /tmp/plugin \
    && cd /tmp/plugin \
    && curl -sL "https://github.com/team-brh/overspray/archive/cc7eefb22b88ae7f70de3e31e2787b58c86a14ae.tar.gz" | tar -xz --strip-components 1 \
    && cd $SOURCEMOD_DIR/plugins \
    && $SOURCEMOD_DIR/scripting/spcomp /tmp/plugin/overspray.sp \
    && rm -rf /tmp/plugin

# Sourcemod configs
ADD --chown=steam config/admin_groups.cfg $SOURCEMOD_DIR/configs/
ADD --chown=steam config/admins_simple.ini $SOURCEMOD_DIR/configs/
ADD --chown=steam config/core.cfg $SOURCEMOD_DIR/configs/
ADD --chown=steam config/maplists.cfg $SOURCEMOD_DIR/configs/
ADD --chown=steam config/mapchooser.cfg $STEAM_GAME_DIR/tf/cfg/sourcemod/