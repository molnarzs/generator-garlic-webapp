#!/usr/bin/env bash
set -e
echo "NODE_ENV=development" >> .env

if [ -n "$NPM_TOKEN" ]; then
  echo "//registry.npmjs.org/:_authToken=$NPM_TOKEN" >> .npmrc
else
  echo "NPM_TOKEN environment variable is not set. You may not be able to install private modules."
  touch .npmrc
fi
