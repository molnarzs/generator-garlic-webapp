#! /usr/bin/env bash
travis enable -R <%= c.scope %>/<%= c.appNameKC %>
travis env set DOCKER_USER <%= c.dockerUser %> -P
travis env set DOCKER_PASSWORD <%= c.dockerPassword %> -P
travis env set GH_TOKEN <%= c.githubToken %>
travis env set NPM_TOKEN <%= c.npmToken %>
travis env set NPM_TOKEN_<%= c.scopeCC %> <%= c.npmToken %>
travis env set SCOPE <%= c.scope %> -P
travis encrypt "<%= c.scope %>:<%= c.slackToken %>" --add notifications.slack.rooms
