#!/usr/bin/env bash

# generate pidfile based on date to prevent locking errors
PIDFILE=$(date +%s)

# Start Sauce Connect and make it non-blocking with ampersand
if [ -z ${PROXY_PASS} ]; then
    ./bin/sc -d ${PIDFILE} -w testuser:${PROXY_PASS} &
else
    ./bin/sc -d ${PIDFILE} &
fi

# Keep track of the Sauce Connect Process ID
SAUCE_CONNECT_PID=$!

# Wait for 10 seconds to give the Sauce Connect a chance to fail if there is an
# issue.
sleep 10

# ps -p Checks if the process is still running. If it is it returns 0,
# otherwise it returns 1
ps -p $SAUCE_CONNECT_PID > /dev/null
TASK_RUNNING=$?

# Check if the process is still running by examining the exit code of ps -p
SAUCE_CONNECT_TEST_RESULT=1
if [ $TASK_RUNNING -eq 0 ]; then
  # Still running so return with safe exit code
  SAUCE_CONNECT_TEST_RESULT=0
fi

kill $SAUCE_CONNECT_PID

exit $SAUCE_CONNECT_TEST_RESULT
