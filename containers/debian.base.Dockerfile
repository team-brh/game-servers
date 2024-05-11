FROM debian:bookworm-slim

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends --no-install-suggests  \
        ca-certificates \
        curl \
        gdb \
        gettext-base \
        lib32gcc-s1 \
        lib32stdc++6 \
        lib32z1 \
        libbz2-1.0:i386 \
        libcurl3-gnutls:i386 \
        libncurses5:i386 \
        libtinfo5:i386 \
        locales \
        unzip \
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
RUN mkdir /console && chown steam /console
USER steam