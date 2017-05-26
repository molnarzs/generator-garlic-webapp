#!/usr/bin/env bash
docker-compose -f docker/docker-compose.backend.yml run <%= conf.backendServerName %> /bin/bash
