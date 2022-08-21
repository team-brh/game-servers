FROM debian:bullseye-slim

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests  \
        ca-certificates=20210119 \
        curl=7.74.0-1.3+deb11u2 \ 
        gdb=10.1-1.7 \
        gettext-base=0.21-4 \
        lib32gcc-s1=10.2.1-6 \
        lib32stdc++6=10.2.1-6 \
        lib32z1=1:1.2.11.dfsg-2+deb11u1 \
        libbz2-1.0:i386=1.0.8-4 \
        libcurl3-gnutls:i386=7.74.0-1.3+deb11u2 \
        libncurses5:i386=6.2+20201114-2 \
        libtinfo5:i386=6.2+20201114-2 \
        locales=2.31-13+deb11u3 \
        unzip=6.0-26 \
        wget=1.21-1+deb11u1 \
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