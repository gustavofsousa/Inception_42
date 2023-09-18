#!/bin/sh

rm -rf /www/wordpress

echo "check if is already"
if [ ! -f "/www/wordpress/wp-config.php" ]
then
    echo "I will install"
	wp core download --path=/www/wordpress/
	if [ $? != 0 ]
	then
		rmdir /www/wordpress
		exit 0
	fi
	cd www/wordpress
    echo "Ready to config wp"
	mv wp-config-sample.php wp-config.php
	sed -i "s/database_name_here/$DB_NAME/g" wp-config.php
	sed -i "s/username_here/$DB_USER/g" wp-config.php
	sed -i "s/password_here/$DB_PASSWORD/g" wp-config.php
	sed -i "s/localhost/$DB_HOST:3306/g" wp-config.php
	sed -i "s-http://example.com-$DOMAIN_NAME-g" wp-config.php

	wp core install --url=$DOMAIN_NAME --title=$SITE_TITLE \
		--admin_user=$ADMIN_USER --admin_password=$ADMIN_PASSWORD \
		--admin_email=$ADMIN_EMAIL --skip-email
	wp user create $EDITOR_USER $EDITOR_EMAIL --user_pass=$EDITOR_PASSWORD
fi

echo "Leaving"
exec php-fpm7 -F