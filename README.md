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
SERVER_PASSWORD | secret         | The password required to join the server. *Cannot be blank!*
SERVER_PORT     | 2456           | The *first* of the three sequential ports the server will use
SERVER_WORLD    | Valheim        | The name of the world file (e.g. Valheim.fwl and Valheim.db)

### Network
Many of the Valheim dedicated server Docker images have `SERVER_PORT` as an argument, however they don't handle it correctly so the port doesn't actually get exposed. A result of this is that all of the Docker images I've found cannot be modified to run on alternate ports. I'm unaware of a way to do something like:
```
EXPOSE ${SERVER_PORT}/udp
EXPOSE $((${SERVER_PORT} + 1))/udp
EXPOSE $((${SERVER_PORT} + 2))/udp
```

Therefore in this Docker image, I have removed all `EXPOSE` declarations and instead require you to specify the ports as a publish - either with Docker CLI (with `-p`) or in docker-compose.yaml (with the `ports:` section) - which will result in Docker doing an implicit EXPOSE for those ports. You **MUST** publish the ports, or they will not be accessible from your host. See the usages below for an example of how to change the ports.

### Volumes
There are three volumes which are mounted:
  - **/opt/steamcmd** - The steamcmd installation. If not mounted, steamcmd will be fully reinstalled every container restart.
  - **/opt/valheim/server** - Valheim dedicated server files. If not mounted, the Valheim dedicated server will be fully reinstalled every container restart.
  - **/opt/valheim/data** - Your worlds directory and admin/ban/permit lists. If not mounted, the data for your worlds will not persist between container restarts.

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
      - SERVER_PORT=2456
      - SERVER_WORLD=Qk4hdQK3Yj
    volumes:
      - /path/to/steamcmd:/opt/steamcmd
      - /path/to/server:/opt/valheim/server
      - /path/to/data:/opt/valheim/data
    ports:
      - 2456-2458:2456-2458/udp
    restart: unless-stopped
```

### Docker Compose with different ports
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
      - SERVER_PORT=2466
      - SERVER_WORLD=Qk4hdQK3Yj
    volumes:
      - /path/to/steamcmd:/opt/steamcmd
      - /path/to/server:/opt/valheim/server
      - /path/to/data:/opt/valheim/data
    ports:
      - 2466-2468:2466-2468/udp
    restart: unless-stopped
```

### Docker CLI
```bash
docker run -it --rm \
    --name valheim-server \
    --env SERVER_NAME="My Super Cool Server" \
    --env SERVER_PASSWORD="somethingrandom" \
    --env SERVER_PORT=2456 \
    --env SERVER_WORLD=Qk4hdQK3Yj \
    -p 2456-2458:2456-2458/udp \
    --volume=valheim_steamcmd:/opt/steamcmd \
    --volume=valheim_server:/opt/valheim/server \
    --volume=valheim_data:/opt/valheim/data \
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

