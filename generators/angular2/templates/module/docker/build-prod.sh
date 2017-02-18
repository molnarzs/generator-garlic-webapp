#!/usr/bin/env bash
set -e
docker/npm.sh build:prod

docker run -i -t --rm \
  -v $(pwd):/app/project \
  <%= conf.dockerRepo %>/workflows-common:${npm_package_config_dockerWorkflowVersion} gulp css html
