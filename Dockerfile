# docker qBittorrent
FROM linuxserver/qbittorrent


# set label
LABEL build_version="SuperNG6.qbittorrent:- ${QBITTORRENT_VER}"
LABEL maintainer="SuperNG6"

# environment settings
ENV TZ=Asia/Shanghai \
WEBUIPORT=8080 \
PUID=1026 PGID=100

# add conf
COPY root/ /

# ports and volumes
VOLUME /downloads /config
EXPOSE 8080  6881  6881/udp
