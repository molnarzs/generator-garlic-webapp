#!/usr/bin/env bash

declare -i timeout=5
make start-prod

while ! TEST_OUTPUT=`curl -s --fail http://localhost:3000/alive`;
    do sleep 0.1;
done

## Assert server response
if [[ "$TEST_OUTPUT" == *"Success"* ]]
then
  echo "Smoke test passed"
else
  echo "Failed asserting that '${TEST_OUTPUT}' contains 'alive'" && exit 1;
fi

make stop-prod
