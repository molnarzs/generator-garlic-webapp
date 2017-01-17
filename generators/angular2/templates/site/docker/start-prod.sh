#!/usr/bin/env bash
docker run -p 8082:80 <%= conf.distImageName %>:latest
