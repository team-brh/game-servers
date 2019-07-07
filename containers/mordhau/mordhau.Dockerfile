FROM team-brh/game-server-base:latest

ENV STEAM_APP_ID 629800
ENV STEAM_APP_DIR $STEAM_GAME_DIR/mordhau-dedicated 

RUN set -x \
# Install Mordhau server dependencies and clean up
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		libfontconfig1=2.11.0-6.7+b1 \
		libpangocairo-1.0-0=1.40.5-1 \
		libnss3=2:3.26.2-1.1+deb9u1 \
		libgconf2-4=3.2.6-4+b1 \
		libxi6=2:1.7.9-1 \
		libxcursor1=1:1.1.14-1+deb9u2 \
		libxss1=1:1.2.2-1 \
		libxcomposite1=1:0.4.4-2 \
		libasound2=1.1.3-5 \
		libxdamage1=1:1.1.4-2+b3 \
		libxtst6=2:1.2.3-1 \
		libatk1.0-0=2.22.0-1 \
		libxrandr2=2:1.5.1-1 \
	&& apt-get clean autoclean \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/* \
# Run Steamcmd and install Mordhau
# Write Server Config
# {{SERVER_PW}}, {{SERVER_ADMINPW}} and {{SERVER_MAXPLAYERS}} gets replaced by entrypoint
	&& su steam -c \
		"${STEAMCMD_DIR}/steamcmd.sh \
		+login anonymous \
		+force_install_dir ${STEAM_APP_DIR} \
		+app_update ${STEAM_APP_ID} validate \
		+quit \
		&& mkdir -p ${STEAM_APP_DIR}/Mordhau/Saved/Config/LinuxServer/ \
		&& { \
			echo '[/Script/Mordhau.MordhauGameMode]'; \
			echo 'PlayerRespawnTime=5.000000'; \
			echo 'BallistaRespawnTime=30.000000'; \
			echo 'CatapultRespawnTime=30.000000'; \
			echo 'HorseRespawnTime=30.000000'; \
			echo 'DamageFactor=1.000000'; \
			echo 'TeamDamageFactor=0.500000'; \
			echo 'MapRotation=HRD_Camp'; \
			echo 'MapRotation=HRD_Grad'; \
			echo 'MapRotation=HRD_Taiga'; \
			echo 'MapRotation=HRD_MountainPeak'; \
			echo 'MapRotation=FFA_Contraband'; \
			echo 'MapRotation=FFA_Tourney'; \
			echo ''; \
			echo '[/Script/Mordhau.MordhauGameSession]'; \
			echo 'bIsLANServer=False'; \
			echo 'MaxSlots={{SERVER_MAXPLAYERS}}'; \
			echo 'ServerName=New Mordhau Server'; \
			echo 'ServerPassword={{SERVER_PW}}'; \
			echo 'AdminPassword={{SERVER_ADMINPW}}'; \
			echo 'Admins=0'; \
			echo 'BannedPlayers=()'; \
		} > ${STEAM_APP_DIR}/Mordhau/Saved/Config/LinuxServer/Game.ini \
		&& { \
			echo '[/Script/EngineSettings.GameMapsSettings]'; \
			echo 'ServerDefaultMap={{SERVER_DEFAULTMAP}}'; \
			echo '[/Script/OnlineSubsystemUtils.IpNetDriver]'; \
			echo 'NetServerMaxTickRate={{SERVER_TICKRATE}}'; \
		} > ${STEAM_APP_DIR}/Mordhau/Saved/Config/LinuxServer/Engine.ini"

ENV SERVER_ADMINPW="brh_sux" \
	SERVER_PW="" \
	SERVER_MAXPLAYERS=8 \
	SERVER_TICKRATE=60 \
	SERVER_PORT=7777 \
	SERVER_QUERYPORT=27015 \
	SERVER_BEACONPORT=15000 \
	SERVER_DEFAULTMAP="\/Game\/Mordhau\/Maps\/DuelCamp\/HRD_CAMP.HRD_CAMP"

# Switch to user steam
USER steam

WORKDIR $STEAM_APP_DIR

VOLUME $STEAM_APP_DIR

# Set Entrypoint
# 1. Update server
# 2. Replace config parameters with ENV variables
# 3. Start the server
# You may not like it, but this is what peak Entrypoint looks like.
ENTRYPOINT ${STEAMCMD_DIR}/steamcmd.sh \
			+login anonymous +force_install_dir ${STEAM_APP_DIR} +app_update ${STEAM_APP_ID} +quit \
		&& /bin/sed -i -e 's/{{SERVER_PW}}/'"$SERVER_PW"'/g' \
			-e 's/{{SERVER_ADMINPW}}/'"$SERVER_ADMINPW"'/g' \
			-e 's/{{SERVER_MAXPLAYERS}}/'"$SERVER_MAXPLAYERS"'/g' ${STEAM_APP_DIR}/Mordhau/Saved/Config/LinuxServer/Game.ini \
		&& /bin/sed -i -e 's/{{SERVER_TICKRATE}}/'"$SERVER_TICKRATE"'/g' \
			-e 's/{{SERVER_DEFAULTMAP}}/'"$SERVER_DEFAULTMAP"'/g' ${STEAM_APP_DIR}/Mordhau/Saved/Config/LinuxServer/Engine.ini \
		&& ${STEAM_APP_DIR}/MordhauServer.sh -log \
			-Port=$SERVER_PORT -QueryPort=$SERVER_QUERYPORT -BeaconPort=$SERVER_BEACONPORT \
			-GAMEINI=${STEAM_APP_DIR}/Mordhau/Saved/Config/LinuxServer/Game.ini \
			-ENGINEINI=${STEAM_APP_DIR}/Mordhau/Saved/Config/LinuxServer/Engine.ini

# Expose ports
EXPOSE 27015 15000 7777