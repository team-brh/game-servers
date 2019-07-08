FROM team-brh/game-server-base:debian

ENV STEAM_APP_ID 380870

USER steam
# Add configs
ADD servertest.ini /home/steam/Zomboid/Server/
ADD servertest_SandboxVars.lua /home/steam/Zomboid/Server/
ADD servertest_spawnpoints.lua /home/steam/Zomboid/Server/
ADD servertest_spawnregions.lua /home/steam/Zomboid/Server/

# Add save directories directory
USER root
RUN mkdir -p /home/steam/Zomboid/db \
    && mkdir -p /home/steam/Zomboid/Saves \
    && chown -R steam:steam /home/steam/Zomboid
USER steam

# Server startup entrypoint
ADD server_entrypoint.sh /steam/
USER root
RUN chmod +x /steam/server_entrypoint.sh
USER steam

ENTRYPOINT [ "/steam/steam_entrypoint.sh", "/steam/server_entrypoint.sh" ]