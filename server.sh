#!/usr/bin/env bash

# Update server
/opt/steamcmd/steamcmd.sh \
    +login anonymous \
    +force_install_dir /opt/valheim/server \
    +app_update 896660 \
    +exit

# Server settings and default values
SERVER_NAME="${SERVER_NAME:-Valheim Server}"
SERVER_PASSWORD="${SERVER_PASSWORD:-secret}"
SERVER_PORT=${SERVER_PORT:-2456}
SERVER_WORLD="${SERVER_WORLD:-Valheim}"

# Valheim game
export LD_LIBRARY=./linux64:${LD_LIBRARY_PATH}
export SteamAppId=892970

# Start the server as a background job
echo "Starting server:"
echo " Name    : ${SERVER_NAME}"
echo " Password: ${SERVER_PASSWORD}"
echo " Port    : ${SERVER_PORT}"
echo " World   : ${SERVER_WORLD}"
/opt/valheim/server/valheim_server.x86_64 \
    -name "${SERVER_NAME}" \
    -password "${SERVER_PASSWORD}" \
    -port ${SERVER_PORT} \
    -world "${SERVER_WORLD}" \
    -savedir "/opt/valheim/data" | tee -a /opt/valheim/server/server.log &

# Trap SIGTERM and perform safe shutdown
trap "kill -s SIGINT $!" SIGTERM

# Wait
while wait $!; [[ $? -ne 0 ]]; do
    true
done

