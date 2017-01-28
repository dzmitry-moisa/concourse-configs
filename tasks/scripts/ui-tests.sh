#!/bin/bash

set -ex

#export SSH_KEY="${HOME}/hackathon-keypair.pem"
export SSH_USER="ubuntu"
export TESTING_HOST="54.194.202.40"

#export TESTING_URL="http://pivotal-drupal-test.tk"
export TEST_CMD="export DISPLAY=:10;java -jar pivotal-hackaton.jar -stories=*.story -browser=firefox -main_url=${TESTING_URL};exit $(cat jbehave/*.stats | grep scenariosFailed | sed 's/.*=//g' | paste -sd+ | bc)"

ssh "${TESTING_HOST}" -l "${SSH_USER}" -i "${SSH_KEY}" "$TEST_CMD"
exit_code=$?

scp -i ${SSH_KEY} "${SSH_USER}@${TESTING_HOST}:jbehave/view/reports.html" ~

exit $exit_code
