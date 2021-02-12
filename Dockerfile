FROM debian:buster
MAINTAINER noblekangaroo

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Valheim Server" \
      org.label-schema.description="Valheim dedicated server" \
      org.label-schema.url="http://github.com/NobleKangaroo/docker-valheim-server" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="http://github.com/NobleKangaroo/docker-valheim-server" \
      org.label-schema.vendor="NobleKangaroo" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

# Install packages
RUN apt-get -y update && \
    apt-get -y install \
        lib32gcc1 \
        lib32stdc++6 \
        curl \
        procps \
        vim

# Install and update steamcmd
RUN mkdir -pv /opt/steamcmd && \
    curl -o \
        /tmp/steamcmd.tar.gz \
        "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" && \
    tar -xzvf \
        /tmp/steamcmd.tar.gz \
        -C /opt/steamcmd/ && \
    ls -la /opt/steamcmd/ && \
    sleep 3 && \
    echo "***** Updating steamcmd *****" && \
    /opt/steamcmd/steamcmd.sh +quit

# Cleanup
RUN apt-get clean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}

# Copy the server script
RUN mkdir -pv /opt/valheim
COPY server.sh /opt/valheim
RUN chmod +x /opt/valheim/server.sh

# Expose ports
EXPOSE 2456-2458/udp

# Mount volumes
VOLUME /opt/valheim/server
VOLUME /opt/valheim/data

# Start the server script
CMD ["/opt/valheim/server.sh"]

