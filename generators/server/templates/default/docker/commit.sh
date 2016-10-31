#!/usr/bin/env bash
docker run -i -t --rm \
  -v $(pwd):/app/project \
  -e GIT_USERNAME="$(git config --get user.name)" \
  -e GIT_EMAIL="$(git config --get user.email)" \
  <%= c.dockerRepo %>/workflows-common npm run commit
