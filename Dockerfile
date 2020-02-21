FROM lsiobase/alpine:3.10 as confimage

# set version label
ARG LIBTORRENT_VER=_1_2
ARG QBITTORRENT_VER=4.2.1

# set label
LABEL build_version="SuperNG6.qbittorrent:- ${QBITTORRENT_VER}"
LABEL maintainer="SuperNG6"

# download qBittorrent
RUN mkdir -p /qbittorrent/usr/local/bin \
&&	wget --no-check-certificate -O /qbittorrent/usr/local/bin/qbittorrent-nox https://git.io/JvLcC

# docker qBittorrent
FROM lsiobase/alpine:3.10

# environment settings
ENV TZ=Asia/Shanghai \
WEBUIPORT=8080 \
PUID=1026 PGID=100

# add local files and install qbitorrent s6
COPY root /
COPY --from=confimage  /qbittorrent  /

# install python3
RUN  apk add --no-cache python3 \
# chmod a+x qbittorrent-nox
chmod a+x /usr/local/bin/qbittorrent-nox  

# ports and volumes
VOLUME /downloads /config
EXPOSE 8080  6881  6881/udp
