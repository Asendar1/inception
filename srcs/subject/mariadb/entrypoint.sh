#!/bin/sh

set -e


if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "first run: initializing first run config"


	mysql_install_db --user=mysql --datadir=/var/lib/mysql

	/usr/bin/mysqld --user=mysql --datadir=/var/lib/mysql &

	sleep 3 # sleep for the server to start and stop the sh to executre mysql -e commands before its ready

	# this will come from the .env file
	mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
	mysql -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
	mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
	mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
	mysql -e "FLUSH PRIVILEGES;"


	mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
fi

exec /usr/bin/mysqld --user=mysql --console
