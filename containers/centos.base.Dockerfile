FROM centos:7


RUN yum update -y -q \
    && yum install -y -q \
    glibc.i686 \
    libstdc++.i686 \
    ncompress \
    libgcc.x86_64 \
    libgcc.i686 \
    zlib.i686 \
    ncurses-libs.i686 \
    libcurl.i686 \
    gettext \
    unzip \
    gdb \
    && yum clean all

# Stupid symbolic link because tf2 depends on libcurl-gnutls
RUN ln -s /usr/lib/libcurl.so.4 /usr/lib/libcurl-gnutls.so.4

ENV STEAMCMD_DIR /steam/steamcmd

RUN useradd steam \
    && mkdir /steam/ \
    && chown steam /steam/
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