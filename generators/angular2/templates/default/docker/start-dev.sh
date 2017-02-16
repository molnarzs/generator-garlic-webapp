#!/usr/bin/env bash
set -e

if [ ! -e 'tsconfig.json' ] || [ ! -e '.env' ] || [ ! -e 'tslint.json' ]; then
  echo "Your project is not set up properly, run 'npm run setup' script"
  exit
fi

DOCKER_COMPOSE="docker-compose  -f docker/docker-compose.dependencies.yml -f docker/docker-compose.webpack.yml -f docker/docker-compose.net.yml"

if [[ $DEBUG ]]; then
  DOCKER_COMPOSE="${DOCKER_COMPOSE} -f docker/docker-compose.debug.yml"
fi

${DOCKER_COMPOSE} up --remove-orphans $@
