#! /usr/bin/env bash
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

