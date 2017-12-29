#!/usr/bin/env bash
docker run -i -t --rm \
  -v $(pwd):/app/project \
  -e GH_USER="$(git config --get user.name)" \
  -e GH_EMAIL="$(git config --get user.email)" \
  garlictech2/workflows-common:${npm_package_config_dockerWorkflowVersion} npm run commit
