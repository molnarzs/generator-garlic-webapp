#!/usr/bin/env bash
docker run \
  -v $(pwd):/app/project \
  -e CI
  -e TRAVIS
  -e TRAVIS_BRANCH \
  <%= c.dockerRepo %>/workflows-common npm run semantic-release
