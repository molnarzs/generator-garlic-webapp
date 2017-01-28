#! /usr/bin/env bash
. .env

IMAGE=$1
TAG=$(npm show @${SCOPE}/${PROJECT} version)
docker tag ${IMAGE} ${IMAGE}:${TAG}