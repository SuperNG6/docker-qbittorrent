FROM debian:buster-slim as confimage

# set version label
ARG LIBTORRENT_VER=_1_2
ARG QBITTORRENT_VER=4.2.1
ARG S6_VER=1.22.1.0

# set label
LABEL build_version="SuperNG6.qbittorrent:- ${QBITTORRENT_VER}"
LABEL maintainer="SuperNG6"

# make
RUN apt-get -y update \
&&	apt-get install -y wget \
&&	mkdir -p /qbittorrent/usr/local/bin \
&&	wget --no-check-certificate -O /qbittorrent/usr/local/bin/qbittorrent-nox https://git.io/JvLcC \
# download s6
&&	mkdir /s6 \
&&	wget --no-check-certificate https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-amd64.tar.gz \
&&	tar -xvzf s6-overlay-amd64.tar.gz -C /s6


# docker qBittorrent
FROM debian:buster-slim

# environment settings
ENV TZ=Asia/Shanghai
ENV WEBUIPORT=8080

# add local files and install qbitorrent s6
COPY root /
COPY --from=confimage  /qbittorrent  /
COPY --from=confimage  /s6 /

# install python3
RUN	apt-get -y update \
&&	apt-get install -y python3 \
# cleanup
&&	apt-get clean \
&&	rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/* \
# s6-setuidgid abc
&&	groupmod -g 1000 users \
&&	useradd -u 1026 -U -d /config -s /bin/false abc \
&&	usermod -G users abc \
# chmod a+x qbittorrent-nox
&&	chmod a+x /usr/local/bin/qbittorrent-nox  

# ports and volumes
VOLUME /downloads /config
EXPOSE 8080  6881  6881/udp

# s6 init
ENTRYPOINT [ "/init" ]