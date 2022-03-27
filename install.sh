#!/usr/bin/env bash

# Check CPU architecture
ARCH=$(uname -m)

echo -e "${INFO} Check CPU architecture ..."
if [[ ${ARCH} == "x86_64" ]]; then
    ARCH="x86_64-qbittorrent-nox"
elif [[ ${ARCH} == "aarch64" ]]; then
    ARCH="aarch64-qbittorrent-nox"
elif [[ ${ARCH} == "armv7l" ]]; then
    ARCH="armv7-qbittorrent-nox"
else
    echo -e "${ERROR} This architecture is not supported."
    exit 1
fi

# Download files
echo "Downloading binary file: ${ARCH}"
TAG=$(cat /qbittorrent/ReleaseTag)
echo "qbittorrent version: ${TAG}"
wget -O ${PWD}/qbittorrent-nox https://github.com/userdocs/qbittorrent-nox-static/releases/download/release-${TAG}/${ARCH}

echo "Download binary file: ${ARCH} completed"
