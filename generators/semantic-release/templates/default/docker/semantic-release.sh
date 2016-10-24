#!/usr/bin/env bash
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
  -e TRAVIS_EVENT_TYPE \
  -e TRAVIS_REPO_SLUG \
  -e TRAVIS_COMMIT \
  -e GH_USER \
  -e GH_TOKEN \
  <%= c.dockerRepo %>/workflows-common npm run semantic-release
