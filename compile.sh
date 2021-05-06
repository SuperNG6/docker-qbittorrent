#!/usr/bin/env bash

# get libtorrent & qbittorrent version
QBV=$(cat ReleaseTag | head -n1)
LIBTV=$(cat ReleaseTag | head -n 2 | tail -n 1 )
# compile libtorrent
git clone https://github.com/arvidn/libtorrent.git
cd libtorrent
git checkout libtorrent-${LIBTV}
./autotool.sh
./configure --disable-debug --enable-encryption --with-boost-libdir=/lib/x86_64-linux-gnu
make clean && make -j$(nproc)
make install-strip

# compile qbittorrent
cd ..
git clone https://github.com/qbittorrent/qBittorrent
cd qBittorrent
git checkout release-${QBV}
./configure CXXFLAGS="-std=c++14" --disable-gui --disable-debug
make clean && make -j$(nproc)
make install

# packing qbittorrent
cd ..
ldd /usr/local/bin/qbittorrent-nox | cut -d ">" -f 2 | grep lib | cut -d "(" -f 1 | xargs tar -chvf /qbittorrent/qbittorrent.tar
mkdir qbittorrent
tar -xvf /qbittorrent/qbittorrent.tar -C qbittorrent
cp --parents /usr/local/bin/qbittorrent-nox qbittorrent
