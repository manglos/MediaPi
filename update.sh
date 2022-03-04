#!/bin/bash
echo "Purging docker images"
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

echo "Updating docker images"
docker pull lscr.io/linuxserver/transmission
docker pull linuxserver/sonarr
docker pull linuxserver/radarr
docker pull linuxserver/jackett

echo "Running transmission"
docker run -d \
  --name=transmission \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=America/New_York \
  -p 9091:9091 \
  -p 51413:51413 \
  -p 51413:51413/udp \
  -v /home/pi/transmission-config:/config \
  -v /media/shield/NVIDIA_SHIELD/transmission/downloads:/downloads \
  -v /media/shield/NVIDIA_SHIELD/transmission/watch:/watch \
  --restart unless-stopped \
  lscr.io/linuxserver/transmission

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
  linuxserver/sonarr

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
  linuxserver/radarr

echo "Running jackett"
docker run \
  --name=jackett \
  -d \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=America/New_York  \
  -p 9117:9117 \
  -v /home/pi/jackett:/config \
  -v /media/shield/NVIDIA_SHIELD/transmission/downloads:/downloads \
  --restart unless-stopped \
  linuxserver/jackett
