#!/bin/bash


export APP_NAME="${repo}-${branch}"
export DB_NAME="${repo}-${branch}-db"


echo "Installing cf client..."
wget "https://cli.run.pivotal.io/stable?release=linux64-binary&source=github" -q -O- | tar -zx
mv cf /usr/local/bin

cd git-branch

cf login -a https://api.system.pcfdemo.tk \
         -u admin \
         -p U3K5eeJSjFj21Aaoy20zlk4BT8k-Cnbk \
         -o ${repo} \
         -s development \
         --skip-ssl-validation

echo "Pushing application ${APP_NAME} to PCF on branch ${branch}..."
cf push "${APP_NAME}" -b php_buildpack --no-start

echo "Enabling ssh..."
cf ssh-enabled ${APP_NAME}


if [ "$(cf service ${DB_NAME} --guid | grep FAILED)" == "FAILED" ]
	then
	echo "Creating ${DB_NAME} database"
	cf create-service p-mysql 100mb "${DB_NAME}"

	echo "Binding ${APP_NAME} to ${DB_NAME}..."
	cf bind-service "${APP_NAME}" "${DB_NAME}"

	if [ -f pivotal.sql ]; then
		cf env ${APP_NAME} > tmp

		password=$(cat tmp | grep \"password\": | awk -F ':' '{print $2}' | sed -e s/\"//g -e s/\ //g -e s/,//g)
		username=$(cat tmp | grep \"username\": | awk -F ':' '{print $2}' | sed -e s/\"//g -e s/\ //g -e s/,//g)
		hostname=$(cat tmp | grep \"hostname\": | awk -F ':' '{print $2}' | sed -e s/\"//g -e s/\ //g -e s/,//g)
		dbname=$(cat tmp | grep jdbcUrl -A 1 | grep name | awk -F ':' '{print $2}' | sed -e s/\"//g -e s/\ //g -e s/,//g -e s/\n//g)
		apt-get update
		apt-get --yes --force-yes install mysql-client
		echo "----"
	    echo "mysql -h ${hostname} -u${username} -p${password} ${dbname}"
	    echo "----"
		mysql -h ${hostname} -u${username} -p${password} ${dbname} < pivotal.sql
	fi
fi


echo "Starting ${APP_NAME}..."
cf start "${APP_NAME}"
