#!/bin/sh

set -e

if [ ! -f "/var/www/wordpress/wp-config.php" ]; then
	echo "First run detected: init wp setup"


	echo "Waiting for mariadb to be ready..."
	while ! mysqladmin ping -h"mariadb" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" --silent; do
		sleep 2
	done

	php83 -d memory_limit=512M /usr/local/bin/wp core download --allow-root

	php83 -d memory_limit=512M /usr/local/bin/wp config create \
		--dbname="${MYSQL_DATABASE}" \
		--dbuser="${MYSQL_USER}" \
		--dbpass="${MYSQL_PASSWORD}" \
		--dbhost="mariadb:3306" \
		--path="/var/www/wordpress" \
		--allow-root

	# Admin
	php83 -d memory_limit=512M /usr/local/bin/wp core install \
		--url="https://${DOMAIN_NAME}" \
		--title="Inception" \
		--admin_user="${WORDPRESS_ADMIN_USER}" \
		--admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
		--admin_email="${WORDPRESS_ADMIN_EMAIL}" \
		--path="/var/www/wordpress" \
		--allow-root

	# Author
	php83 -d memory_limit=512M /usr/local/bin/wp user create \
		"${WORDPRESS_USER}" \
		"${WORDPRESS_USER_EMAIL}" \
		--user_pass="${WORDPRESS_USER_PASSWORD}" \
		--role=author \
		--path="/var/www/wordpress" \
		--allow-root

	echo "WordPress deployment completed successfully."
fi

echo "Launching PHP-FPM container..."

exec /usr/sbin/php-fpm83 -F
