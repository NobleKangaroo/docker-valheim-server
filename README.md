# docker-valheim-server
Dedicated server for [Valheim](https://store.steampowered.com/app/892970/Valheim/).

Docker image available at https://hub.docker.com/r/noblekangaroo/valheim-server

## About
A simple dedicated server Docker image for [Valheim](https://store.steampowered.com/app/892970/Valheim/) without any unnecessary dependencies (Rust, Odin, etc). This image contains everything you need to run a Valheim dedicated server, either as a standalone Docker container or using docker-compose. The image will install and use [steamcmd](https://developer.valvesoftware.com/wiki/SteamCMD) to download the dedicated server and keep it up to date.

### Environment variables
There are three environment variables you can configure:
Variable        | Default        | Description
--------------- | -------------- | --------------------------------------------------
SERVER_NAME     | Valheim Server | The name displayed in the server list
SERVER_PASSWORD | secret         | The password required to enter. *Cannot be blank!*
SERVER_WORLD    | Valheim        | The world seed you would like to play on

### Network
Many of the Valheim dedicated server Docker images have `SERVER_PORT` as an argument, however they don't handle it correctly so the port doesn't actually get exposed. A result of this is that all of the Docker images I've found cannot be modified to run on alternate ports. I'm unaware of a way to do something like:
```
EXPOSE ${SERVER_PORT}/udp
EXPOSE $((${SERVER_PORT} + 1))/udp
EXPOSE $((${SERVER_PORT} + 2))/udp
```

Therefore in this Docker image, ports 2456 through 2458 (UDP) are configured as an `EXPOSE`. You can use these ports, or map them to the host using ports of your own choosing - either with Docker CLI (with `-p`) or in docker-compose.yaml (with the `ports:` section). See the usages below for more info.

### Volumes
There's two volumes that are mounted:
  - **/opt/valheim/server** - Valheim server files
  - **/opt/valheim/data** - Your worlds directory and admin/ban/permit lists

### Other paths
Additionally, the following paths are populated:
  - **/opt/steamcmd** - steamcmd installation
  - **/opt/steam** - Steam client installation

## Usage
Using this Docker image is easy. Follow one of the examples below to get started.

### Docker Compose (recommended)
```yaml
---
version: 3.0
services:
  valheim-server:
    container_name: valheim-server
    image: noblekangaroo/valheim-server
    environment:
      - SERVER_NAME=My Super Cool Server
      - SERVER_PASSWORD=somethingrandom
      - SERVER_WORLD=Qk4hdQK3Yj
    volumes:
      - /path/to/data:/opt/valheim/data
      - /path/to/server:/opt/valheim/server
    ports:
      - 2456-2458:2456-2458/udp
    restart: unless-stopped
```

### Docker CLI
```bash
docker run -it --rm \
    --name valheim-server \
    --env SERVER_NAME="My Super Cool Server" \
    --env SERVER_PASSWORD="somethingrandom" \
    --env SERVER_WORLD=Qk4hdQK3Yj \
    -p 2456-2458:2456-2458/udp \
    --volume=valheim_data:/opt/valheim/data \
    --volume=valheim_server:/opt/valheim/server \
    noblekangaroo/valheim-server
```

While running Docker Compose or Docker CLI interactively (not `-d` mode), you can simply press `CTRL+C` once to gracefully stop the server.

## Issues
If you encounter any issues, feel free to open a Github issue. As I do this on my free time, please bear with me while I work through the issue.

## Shoutouts
I'd like to take a moment to thank the owners of the following images I looked to for inspiration:
  - Respawner: https://github.com/respawner/docker-steamcmd
  - CanadaBry: https://github.com/CanadaBry/ValheimDocker
  - Nopor: https://github.com/nopor/docker-valheim

