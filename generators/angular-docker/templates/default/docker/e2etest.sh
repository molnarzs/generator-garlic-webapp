#!/usr/bin/env bash
DOCKER_COMPOSE_BASE="docker-compose -f docker/docker-compose.dependencies.yml -f docker/docker-compose.webpack.yml -f docker/docker-compose.e2e.yml"

if [ -n "TRAVIS" ]; then
  DOCKER_COMPOSE_BASE="${DOCKER_COMPOSE_BASE} -f docker/docker-compose.debug.yml"
  DOCKER_RUN_FLAGS="--service-ports"
fi

if [ "$1" == "bash" ]; then
  ${DOCKER_COMPOSE_BASE} run --entrypoint=/bin/bash <%= c.e2eTesterName %>
elif [ "$1" == "stop" ]; then
  ${DOCKER_COMPOSE_BASE} down
else
  ${DOCKER_COMPOSE_BASE} run ${DOCKER_RUN_FLAGS} <%= c.e2eTesterName %> $@
fi
