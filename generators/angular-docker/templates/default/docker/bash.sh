#!/usr/bin/env bash
docker-compose -f docker/docker-compose.local.yml -f docker/docker-compose.dev.yml run webpack_server /bin/bash