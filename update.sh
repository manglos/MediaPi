#!/bin/bash
echo "Purging docker images"
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

echo "Updating docker images"
docker pull mjenz/rpi-deluge
docker pull linuxserver/sonarr:preview
docker pull linuxserver/radarr:preview
docker pull linuxserver/jackett

echo "Running deluge"
docker run -d   --name=deluge   --net=host   -e PUID=1000   -e PGID=1000   -e TZ=Europe/London   -v /home/pi/deluge-config:/config   -v /media/shield/NVIDIA_SHIELD/deluge/downloads:/downloads   --restart unless-stopped   ghcr.io/linuxserver/deluge

echo "Running sonarr"
docker run \
  --name=sonarr \
  -d \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=America/New_York \
  -e UMASK_SET=022 `#optional` \
  -p 8989:8989 \
  -v /home/pi/sonarr-config:/config \
  -v /media/shield/NVIDIA_SHIELD:/shield \
  --restart unless-stopped \
  linuxserver/sonarr:preview

echo "Running radarr"
docker run \
  --name=radarr \
  -d \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=America/New_York \
  -e UMASK_SET=022 `#optional` \
  -p 7878:7878 \
  -v /home/pi/radarr-config:/config \
  -v /media/shield/NVIDIA_SHIELD:/shield \
  --restart unless-stopped \
  linuxserver/radarr:3.0.0.2998-ls7

echo "Running jackett"
docker run \
  --name=jackett \
  -d \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=America/New_York  \
  -p 9117:9117 \
  -v /home/pi/jackett:/config \
  -v /media/shield/NVIDIA_SHIELD/deluge/downloads:/downloads \
  --restart unless-stopped \
  linuxserver/jackett:latest
