#!/usr/bin/env bash
. .env
docker run -i -t -v $(pwd):/app/project ${DOCKER_REGISTRY}/workflows-common npm run commit