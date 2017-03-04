#!/usr/bin/env bash

# DON'T MODIFY THIS FILE, IT'S GENERATED
docker run -i -t \
  -v $(pwd):/app/project \
  -e CI \
  -e TRAVIS \
  -e TRAVIS_BRANCH \
  -e TRAVIS_EVENT_TYPE \
  -e TRAVIS_REPO_SLUG \
  -e TRAVIS_COMMIT \
  -e GH_USER \
  -e GH_TOKEN \
  <%= c.dockerRepo %>/workflows-server:${npm_package_config_dockerWorkflowVersion} hooks/travis/$1
