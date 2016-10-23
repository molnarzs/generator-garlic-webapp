#!/usr/bin/env bash
docker-compose -f docker/docker-compose.webpack.yml run <%= c.webpackServerName %> /bin/bash