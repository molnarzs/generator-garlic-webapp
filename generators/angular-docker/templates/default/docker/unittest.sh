#!/usr/bin/env bash
docker-compose -f docker/docker-compose.webpack.yml \
  -f docker/docker-compose.debug.yml \
  run <%= c.webpackServerName %> npm run unittest:docker