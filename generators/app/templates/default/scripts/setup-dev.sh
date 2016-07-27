#!/usr/bin/env bash
cp node_modules/garlictech-workflows-client/scripts/client/sample-env .env
source .env
source ${WORKFLOWS_ROOT}/scripts/client/setup-dev.sh
