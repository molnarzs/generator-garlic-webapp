#!/usr/bin/env bash

declare -i timeout=5

while ! TEST_OUTPUT=`curl -s --fail http://localhost:3000`;
    do sleep 0.1;
done

## Assert server response
if [[ "$TEST_OUTPUT" == *"started"* ]]
then
  echo "Smoke test passed"
else
  echo "Failed asserting that '${TEST_OUTPUT}' contains 'started'" && exit 1;
fi
