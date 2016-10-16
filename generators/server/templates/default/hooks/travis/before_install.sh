#!/usr/bin/env bash
cp hooks/travis/env ${TRAVIS_BUILD_DIR}/.env

if [ "$TRAVIS_EVENT_TYPE" == "pull_request" ]; then  
  echo "Tokens are ignored in pull requests, using dummy tokens."
  cp ${TRAVIS_BUILD_DIR}/hooks/travis/dummy_tokens.env ${TRAVIS_BUILD_DIR}/tokens.env
else

fi
