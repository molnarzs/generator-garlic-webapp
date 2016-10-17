#!/usr/bin/env bash

# Push an empty commit to the github repos defining machines using this service.
# The machines will pull the latest image and restart the server.

set -e

function notify_dependency {
  REPO=$(eval "echo $1")
  LOCAL_REPO=/tmp/machine_repo
  git clone $REPO $LOCAL_REPO
  pushd $LOCAL_REPO > /dev/null
  git commit -m "fix(dependency): A dependent external service changed. Repo: ${TRAVIS_REPO_SLUG} - commit: ${TRAVIS_COMMIT}" --allow-empty
  git push
  popd > /dev/null
  rm -rf $LOCAL_REPO
}

if [ "$TRAVIS_EVENT_TYPE" == "pull_request" ]; then  
  echo "Dependent projects are not notified in pull requests."
else
  notify_dependency $(cat depending_on_this)
fi
