#! /usr/bin/env bash
travis enable -R <%= c.scope %>/<%= c.appNameKC %>
travis env set DOCKER_USER <%= c.dockerUser %> -P
travis env set DOCKER_PASSWORD <%= c.dockerPassword %> -P
travis env set GH_USER <%= c.githubUser %>
travis env set GH_TOKEN <%= c.githubToken %>
travis encrypt "<%= c.scope %>:<%= c.slackToken %>" --add notifications.slack.rooms
