#! /usr/bin/env bash
. .env
travis encrypt-file tokens.env -r ${SCOPE}/${PROJECT} --add