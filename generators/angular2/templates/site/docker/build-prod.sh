#!/usr/bin/env bash
set -e
docker/npm.sh build:prod
docker build -t <%= conf.distImageName %>:${npm_package_config_dockerWorkflowVersion} .
