#!/usr/bin/env bash
docker-compose -f docker/docker-compose.local.yml run webpack_server npm run unittest:docker