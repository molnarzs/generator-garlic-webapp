#!/usr/bin/env bash
cp hooks/travis/sample-env ${TRAVIS_BUILD_DIR}/.env
cp ${TRAVIS_BUILD_DIR}/hooks/travis/dummy_tokens.env ${TRAVIS_BUILD_DIR}/tokens.env

if [ "$TRAVIS_EVENT_TYPE" == "pull_request" ]; then  
  echo "Tokens are ignored in pull requests, using dummy tokens."
fi
