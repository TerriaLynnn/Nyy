#!/bin/sh
# This script runs inside the container when it starts.
set -e

# 1. Generate the initial config.yaml from the template and environment variables (Secrets).
envsubst < /home/node/app/config.template.yaml > /home/node/app/config.yaml

# 2. Forcibly set all necessary plugin-related configurations.
sed -i 's/^ *whitelistMode:.*$/whitelistMode: false/' /home/node/app/config.yaml
sed -i 's/^ *enableServerPlugins:.*$/enableServerPlugins: true/' /home/node/app/config.yaml
sed -i 's/^ *enableServerPluginsAutoUpdate:.*$/enableServerPluginsAutoUpdate: false/' /home/node/app/config.yaml
sed -i 's/^ *extensions\.enabled:.*$/extensions.enabled: true/' /home/node/app/config.yaml

# 3. Start the main application.
exec node server.js
