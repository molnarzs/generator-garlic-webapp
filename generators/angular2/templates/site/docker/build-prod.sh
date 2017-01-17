#!/usr/bin/env bash
set -e
docker/npm.sh build:prod
docker build -t <%= conf.distImageName %>:latest .
