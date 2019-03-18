#!/bin/bash

# Docker-compose truncates first line of output.
# Make that first line non-essential.
echo "Hello from docker webpack entrypoint.sh"

cd /home/node/app

if [[ "$NODE_ENV" = 'development' ]]; then
  echo "Installing npm packages..."
  npm install
  exec npm run watch
fi
