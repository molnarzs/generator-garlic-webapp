#!/usr/bin/env bash
DOCKER_COMPOSE="docker-compose -f docker/docker-compose.local.yml -f docker/docker-compose.dev.yml -f docker/docker-compose.e2e.yml"

if [ $# -eq 0 ]; then
  $DOCKER_COMPOSE run -remove-orphans <%= c.e2eTesterName %>
elif [ $1 == "bash" ]; then
  $DOCKER_COMPOSE run --entrypoint=/bin/bash <%= c.e2eTesterName %>
else
  $DOCKER_COMPOSE $@
fi
