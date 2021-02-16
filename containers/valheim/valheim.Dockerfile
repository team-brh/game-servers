FROM team-brh/hl2:latest

ENV STEAM_APP_ID 896660
ENV VALHEIM_SAVE_DIR /valheim_save

ADD --chown=steam ./config/adminlist.txt $VALHEIM_SAVE_DIR/

USER root
RUN mkdir -p $VALHEIM_SAVE_DIR/worlds \
    && chown -R steam $VALHEIM_SAVE_DIR
USER steam


# Server startup entrypoint
ADD server_entrypoint.sh /steam/
USER root
RUN chmod +x /steam/server_entrypoint.sh
USER steam


ENTRYPOINT [ "/steam/steam_entrypoint.sh", "/steam/server_entrypoint.sh" ]
