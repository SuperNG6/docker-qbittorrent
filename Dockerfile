FROM superng6/alpine:3.24.4-s6v3 AS builder
LABEL maintainer="SuperNG6"

WORKDIR /qbittorrent

COPY install.sh /qbittorrent/
COPY ReleaseTag /qbittorrent/

ARG QBITTORRENT_VERSION

RUN set -ex \
	&& chmod +x /qbittorrent/install.sh \
	&& /qbittorrent/install.sh

# docker qBittorrent
FROM superng6/alpine:3.24.4-s6v3

# environment settings
ENV TZ=Asia/Shanghai \
    WEBUI_PORT=8080 \
    PUID=1026 PGID=100 UMASK_SET=022\
    TL=https://cdn.jsdelivr.net/gh/XIU2/TrackersListCollection@master/best.txt \
    UT=true

# add local files and install qbitorrent
COPY root /
COPY --from=builder  /qbittorrent/qbittorrent-nox   /usr/local/bin/qbittorrent-nox

# install python3
RUN  apk add --no-cache python3 \
&&   python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3, 13) else sys.version)' \
&&   rm -rf /var/cache/apk/*   \
&&   chmod a+x /usr/local/bin/qbittorrent-nox \
&&   /usr/local/bin/qbittorrent-nox --version

# ports and volumes
VOLUME /downloads /config
EXPOSE 8080  6881  6881/udp
