#!/bin/bash

docker build \
  --tag superng6/qbittorrent:latest-s6v3 \
  --force-rm \
    .
