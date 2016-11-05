#!/usr/bin/env bash
docker-compose -f docker/docker-compose.webpack.yml \
  -f docker/docker-compose.net.yml \
  -f docker/docker-compose.debug.yml \
  up --remove-orphans $@
