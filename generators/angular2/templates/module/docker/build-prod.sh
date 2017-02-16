#!/usr/bin/env bash
set -e
docker/npm.sh build:prod

docker run -i -t --rm \
  -v $(pwd):/app/project \
  <%= conf.dockerRepo %>/workflows-common gulp css html
