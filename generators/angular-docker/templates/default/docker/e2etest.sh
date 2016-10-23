#!/usr/bin/env bash
DOCKER_COMPOSE="docker-compose -f docker/docker-compose.webpack.yml -f docker/docker-compose.e2e.yml"

if [ -n "TRAVIS" ]; then
  DOCKER_COMPOSE="${DOCKER_COMPOSE} -f docker/docker-compose.debug.yml"
fi

if [ $# -eq 0 ]; then
  $DOCKER_COMPOSE run <%= c.e2eTesterName %>
elif [ $1 == "bash" ]; then
  $DOCKER_COMPOSE run --entrypoint=/bin/bash <%= c.e2eTesterName %>
else
  $DOCKER_COMPOSE $@
fi
