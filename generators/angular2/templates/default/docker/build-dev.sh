#!/usr/bin/env bash
docker-compose -f docker/docker-compose.webpack.yml build $@
# /app/package_project.json is the package.json in this project, copied into the container.
docker-compose -f docker/docker-compose.webpack.yml run <%= conf.webpackServerName %> scripts/cat-package-json.sh > package.json
