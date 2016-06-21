#!/usr/bin/env bash
cp node_modules/@garlictech/workflows/scripts/client/sample-env .env
source .env
source ${WORKFLOWS_ROOT}/scripts/client/postinstall.sh