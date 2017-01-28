#!/bin/bash

set -ex

exit_code=$(curl 54.194.202.40:7080/run_tests/${TESTING_URL})

exit $exit_code
