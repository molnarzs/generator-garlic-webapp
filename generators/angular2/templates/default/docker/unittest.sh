#!/usr/bin/env bash
DOCKER_COMPOSE="docker-compose -f docker/docker-compose.webpack.yml -f docker/docker-compose.unittest.yml"

if [[ $DEBUG ]]; then
  DOCKER_COMPOSE="${DOCKER_COMPOSE} -f docker/docker-compose.debug.yml"
fi

${DOCKER_COMPOSE} run --service-ports <%= conf.webpackServerName %> npm run $@
