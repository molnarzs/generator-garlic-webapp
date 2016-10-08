#!/usr/bin/env bash

SCOPE=garlictech
DOCKER_REPO_HOST=docker.${SCOPE}.com
IMAGE_NAME=${1}

SCOPE_CAPITALIZED="$(tr '[:lower:]' '[:upper:]' <<< ${SCOPE:0:1})${SCOPE:1}"
NPM_TOKEN_varname=NPM_TOKEN_$SCOPE_CAPITALIZED

COLOR='\033[1;33m'
NC='\033[0m' # No Color

if [ -n "${!NPM_TOKEN_varname}" ]; then
  echo "//registry.npmjs.org/:_authToken=${!NPM_TOKEN_varname}" > .npmrc
elif [ -n "${NPM_TOKEN}" ]; then
  echo "//registry.npmjs.org/:_authToken=${NPM_TOKEN}" > .npmrc
else

  echo -e "\n${COLOR}WARNING: either $NPM_TOKEN_varname or NPM_TOKEN environment variable should be set. You may not be able to install private modules.${NC}\n"
  touch .npmrc
fi

if [ -z "$DOCKER_USER" ]; then
  echo -e "\n${COLOR}WARNING: DOCKER_USER environment variable is not set.${NC}\n"
fi

if [ -z "$DOCKER_PASSWORD" ]; then
  echo -e "\n${COLOR}WARNING: DOCKER_PASSWORD environment variable is not set.${NC}\n"
fi

docker build -t ${DOCKER_REPO_HOST}/${IMAGE_NAME} .
docker login -u docker -p docker https://${DOCKER_REPO_HOST}
docker push ${DOCKER_REPO_HOST}/${IMAGE_NAME}
