FROM debian:stable

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y \
        bc \
        binutils \
        bsdmainutils \
        bzip2 \
        ca-certificates \
        curl \
        default-jre \
        file \
        gettext-base \
        gzip \
        jq \
        lib32gcc1 \
        libstdc++6 \
        libstdc++6:i386 \
        mailutils \
        postfix \
        python \
        rng-tools \
        unzip \
        util-linux \
        wget \
    && rm -rf /var/lib/apt/lists/*

ENV STEAMCMD_DIR /steam/steamcmd

RUN useradd steam \
    && mkdir /steam/ \
    && chown steam /steam/ \
    && mkdir /home/steam/ \
    && chown steam /home/steam/

USER steam

RUN mkdir $STEAMCMD_DIR \
    && cd $STEAMCMD_DIR \
    && curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxf - \
    && mkdir -p /home/steam/.steam/ \
    && ln -s $STEAMCMD_DIR/linux32/ /home/steam/.steam/sdk32 \
    && ./steamcmd.sh +login anonymous +quit


ENV STEAM_GAME_DIR /steam/game
ADD steam_entrypoint.sh /steam/
ADD steam_app_update.txt /steam/

USER root
RUN chmod +x /steam/steam_entrypoint.sh
USER steam