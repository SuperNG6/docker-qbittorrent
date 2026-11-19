#!/usr/bin/env bash

set -e

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
TAG=${QBITTORRENT_VERSION:-$(cat /qbittorrent/ReleaseTag)}
BINARY="$PWD/qbittorrent-nox"
URL="https://github.com/userdocs/qbittorrent-nox-static/releases/download/release-${TAG}/${ARCH}"

echo "Downloading ${ARCH} for qBittorrent ${TAG}"
if ! wget -O "$BINARY" "$URL" || [[ ! -s "$BINARY" ]]; then
    echo "Failed to download a non-empty qBittorrent ${TAG} binary for ${ARCH}" >&2
    exit 1
fi
