#!/usr/bin/env bash
docker run -v $(pwd):/app/project <%= c.dockerRepo %>/workflows-common gulp $@
