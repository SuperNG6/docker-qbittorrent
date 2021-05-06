#!/usr/bin/env bash

# get libtorrent & qbittorrent version
QBV=$(cat ReleaseTag | head -n1)
LIBTV=$(cat ReleaseTag | head -n 2 | tail -n 1 )
# compile libtorrent
git clone https://github.com/arvidn/libtorrent.git
cd libtorrent
git checkout libtorrent-${LIBTV}
./autotool.sh
./configure --disable-debug --enable-encryption
make clean && make -j$(nproc)
make install-strip

# compile qbittorrent
cd /qbittorrent
git clone https://github.com/qbittorrent/qBittorrent
cd qBittorrent
git checkout release-${QBV}
./configure --disable-gui --disable-debug
make clean && make -j$(nproc)
make install

# packing qbittorrent
ldd /usr/local/bin/qbittorrent-nox | cut -d ">" -f 2 | grep lib | cut -d "(" -f 1 | xargs tar -chvf /qbittorrent/qbittorrent.tar
mkdir /qbittorrent/qbittorrent
tar -xvf /qbittorrent/qbittorrent.tar -C /qbittorrent/qbittorrent
cp --parents /usr/local/bin/qbittorrent-nox /qbittorrent/qbittorrent
