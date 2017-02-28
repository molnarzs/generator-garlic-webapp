#! /usr/bin/env bash

set -e
echo "Generating .env..."
cp docker/sample-env .env

DOCKER_RUN_CMD="docker-compose -f docker/docker-compose.yml run -T <%= c.scope %>.<%= c.appNameKC %>.dev"
# /app/package_project.json is the package.json in this project, copied into the container.
echo "Updating package.json..."
${DOCKER_RUN_CMD} scripts/cat-package-json.sh > package.json
echo "Updating tslint.json..."
${DOCKER_RUN_CMD} cat tslint.json > tslint.json
