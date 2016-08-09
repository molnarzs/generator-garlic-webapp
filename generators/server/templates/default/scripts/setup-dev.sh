#!/usr/bin/env bash
cp node_modules/garlictech-workflows-server/scripts/sample-env .env
source .env
source ${WORKFLOWS_ROOT}/scripts/setup-dev.sh