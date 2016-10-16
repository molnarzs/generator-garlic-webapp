#!/usr/bin/env bash
docker-compose -f docker/docker-compose.local.yml -f docker/docker-compose.dev.yml build --pull $@
