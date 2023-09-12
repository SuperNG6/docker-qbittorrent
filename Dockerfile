FROM lsiobase/alpine:3.17-69ac1933-ls26 as builder
LABEL maintainer="SuperNG6"

WORKDIR /qbittorrent

COPY install.sh /qbittorrent/
COPY ReleaseTag /qbittorrent/

RUN set -ex \
	&& chmod +x /qbittorrent/install.sh \
	&& /qbittorrent/install.sh

# docker qBittorrent
FROM lsiobase/alpine:3.17-69ac1933-ls26

# environment settings
ENV TZ=Asia/Shanghai \
    WEBUI_PORT=8080 \
    PUID=1026 PGID=100 UMASK_SET=022\
    TL=https://githubraw.sleele.workers.dev/XIU2/TrackersListCollection/master/best.txt \
    UT=true

# add local files and install qbitorrent
COPY root /
COPY --from=builder  /qbittorrent/qbittorrent-nox   /usr/local/bin/qbittorrent-nox

# install python3
RUN  apk add --no-cache python3 \
&&   rm -rf /var/cache/apk/*   \
&&   chmod a+x  /usr/local/bin/qbittorrent-nox  

# ports and volumes
VOLUME /downloads /config
EXPOSE 8080  6881  6881/udp
