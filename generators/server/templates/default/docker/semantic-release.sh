#!/usr/bin/env bash
. .env

if [ "$1" == "-f" ]; then
  export CI=true
  export TRAVIS=true
  export TRAVIS_BRANCH=master
fi

docker run \
  -v $(pwd):/app/project \
  -e CI \
  -e TRAVIS \
  -e TRAVIS_BRANCH \
  <%= c.dockerRepo %>/workflows-common:<%= c.dockerWorkflowVersion %> npm run semantic-release
