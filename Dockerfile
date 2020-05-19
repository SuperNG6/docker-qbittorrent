# docker qBittorrent
FROM linuxserver/qbittorrent

# set label
LABEL maintainer="SuperNG6"

# environment settings
ENV TZ=Asia/Shanghai \
WEBUI_PORT=8080 \
PUID=1026 PGID=100 \
UT=true

# add conf
COPY root/ /

# ports and volumes
VOLUME /downloads /config
EXPOSE 8080  6881  6881/udp
