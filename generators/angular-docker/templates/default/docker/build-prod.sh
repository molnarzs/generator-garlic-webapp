#!/usr/bin/env bash
set -e
docker/npm.sh clean:build
docker/npm.sh build:prod
docker build -t <%= c.distImageName %>:latest .
