#!/bin/sh

export APP_NAME="drupal-app-demo-${branch}"
export DB_NAME="drupaldb-${branch}"

echo "Installing cf client..."
wget "https://cli.run.pivotal.io/stable?release=linux64-binary&source=github" -q -O- | tar -zx
mv cf /usr/local/bin

cd git-branch

cf login -a https://api.system.pcfdemo.tk \
         -u admin \
         -p U3K5eeJSjFj21Aaoy20zlk4BT8k-Cnbk \
         -o dev \
         -s test \
         --skip-ssl-validation

echo "Pushing application ${APP_NAME} to PCF on branch ${branch}..."
cf push "${APP_NAME}" -b php_buildpack --no-start

echo "Creating ${DB_NAME} database"
cf create-service p-mysql 100mb "${DB_NAME}"

echo "Binding ${APP_NAME} to ${DB_NAME}..."
cf bind-service "${APP_NAME}" "${DB_NAME}"

"Starting ${APP_NAME}..."
cf start "${APP_NAME}"
