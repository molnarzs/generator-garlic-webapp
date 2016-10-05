#!/usr/bin/env bash
docker-compose -f docker/docker-compose.local.yml run <%= c.webpackServerName %> npm run unittest:docker