#!/usr/bin/env bash
if [ $# -eq 0 ]; then
  docker-compose -f docker/docker-compose.e2e.yml up --force-recreate
elif [ $1 == "bash" ]; then
  docker-compose -f docker/docker-compose.e2e.yml run <%= c.e2eTesterName %> /bin/bash
else
   docker-compose -f docker/docker-compose.e2e.yml $@
fi
