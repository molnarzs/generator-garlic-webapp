#!/usr/bin/env bash

declare -i timeout=5

while ! TEST_OUTPUT=`curl -s --fail http://localhost:3000/alive`;
    do sleep 0.1;
done

## Assert server response
if [ "$TEST_OUTPUT" != "Success" ]
then
  echo "Failed asserting that '${TEST_OUTPUT}' equals 'Success'" && exit 1;
else
  echo "Smoke test passed"
fi
