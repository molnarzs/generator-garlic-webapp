#! /usr/bin/env bash
. .env

IMAGE=$1
VERSION=$(npm show @${SCOPE}/${PROJECT} version)
BUILD_ID=$(git log -1 --pretty=format:%h)
DOCKER_TAG=${IMAGE}:${VERSION}-${BUILD_ID}
echo "New docker tag: $DOCKER_TAG"
docker tag ${IMAGE} ${DOCKER_TAG}
