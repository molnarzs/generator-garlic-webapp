#! /usr/bin/env bash
travis enable -R <%= c.scope %>/<%= c.appNameKC %>
travis env set DOCKER_USER <%= c.dockerUser %> -P
travis env set DOCKER_PASSWORD <%= c.dockerPassword %> -P
travis encrypt "<%= c.scope %>:<%= c.slackToken %>" --add notifications.slack.rooms

if [ "<%= c.dockerMachine %>" != "" ]; then
  KEYFILE=travis_key
  echo "You\'re now generating SSH keys for the docker machine of the project."
  echo "Use an empty password for the key!"
  ssh-keygen -f $KEYFILE
  travis encrypt-file $KEYFILE | grep openssl >> hooks/travis/before_install.sh
  echo $KEYFILE >> .gitignore
  echo ${KEYFILE}.enc >> .gitignore
  echo "Now, you ssh to the docker machine."
  KEY=$(cat ${KEYFILE}.pub)
  ssh <%= c.dockerMachine %> 'cat $KEY >> .ssh/authorized_keys'
  rm ${KEYFILE}.pub
fi

