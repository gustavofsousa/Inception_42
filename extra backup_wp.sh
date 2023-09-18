
#!/bin/bash

if [ ! -f $WORDPRESS_DIR ]; then
echo "switch to $WORDPRESS_DIR"
cd $WORDPRESS_DIR

echo "Installing and starting WordPress"
		wget -q -O - https://wordpress.org/latest.tar.gz | tar -xz -C $WORDPRESS_DIR --strip-components=1
		chmod -R +rwx $WORDPRESS_DIR

		wp --path=$WORDPRESS_DIR --allow-root config create --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASSWORD" --dbhost=$DB_HOST --dbprefix='wp_'
		wp --path=$WORDPRESS_DIR --allow-root core install --url="$DOMAIN_NAME" --title="$SITE_TITLE" --admin_user="$ADMIN_USER" --admin_password="$ADMIN_PASSWORD" --admin_email="$ADMIN_EMAIL"
		wp --path=$WORDPRESS_DIR --allow-root user create "$EDITOR_USER" "$EDITOR_USER" --role='editor' --user_pass="$EDITOR_PASSWORD"
		wp --path=$WORDPRESS_DIR --allow-root user create "$SUBSCRIBER_USER" "$SUBSCRIBER_EMAIL" --role='subscriber' --user_pass="$SUBSCRIBER_PASSWORD"

fi

chmod -R 777 $WORDPRESS_DIR
mkdir -p /run/php/
chown www-data:www-data /run/php/

exec php-fpm7.4 -F


--- mine

FROM debian:bullseye

RUN apt update -y \
    && apt upgrade \
    && apt install apt-utils \
    && apt install php-fpm php-mysql -y \
    && apt install wget -y \
    && apt install mariadb-client -y

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/php-fpm.conf /etc/php/7.4/fpm/pool.d/
COPY ./tools/setup.sh /usr/local/bin

ENTRYPOINT ["sh", "/usr/local/bin/setup.sh"]

------- mine
#!/bin/sh

echo "check if it already exist"
if [ ! -f "$WORDPRESS_DIR/wp-config.php" ]; then
    # Download and extract WordPress
    wp core download --path="$WORDPRESS_DIR"
    echo "ready to install"
    if [ $? -ne 0 ]; then
        echo "WordPress download failed."
        exit 1
    fi

    # Change directory to WordPress installation
    cd "$WORDPRESS_DIR"
    echo "switch to $WORDPRESS_DIR"


    # Configure wp-config.php
    mv wp-config-sample.php wp-config.php
    sed -i "s/database_name_here/$DB_NAME/g" wp-config.php
    sed -i "s/username_here/$DB_USER/g" wp-config.php
    sed -i "s/password_here/$DB_PASSWORD/g" wp-config.php
    sed -i "s/localhost/$DB_HOST/g" wp-config.php

    # Install WordPress
    sudo -u $DB_USER -i -- wp core install --url="$DOMAIN_NAME" --title="$SITE_TITLE" \
        --admin_user="$ADMIN_USER" --admin_password="$ADMIN_PASSWORD" \
        --admin_email="$ADMIN_EMAIL" --skip-email

    # Create WordPress users
    sudo -u $DB_USER -i -- wp user create "$EDITOR_USER" "$EDITOR_EMAIL" --role='editor' --user_pass="$EDITOR_PASSWORD"
    sudo -u $DB_USER -i -- wp user create "$SUBSCRIBER_USER" "$SUBSCRIBER_EMAIL" --role='subscriber' --user_pass="$SUBSCRIBER_PASSWORD"

    echo "all set done in wordpress"
fi

echo "Leaving"

# Set appropriate permissions
chmod -R 755 "$WORDPRESS_DIR"
mkdir -p /run/php/
chown www-data:www-data /run/php/

# Start PHP-FPM
exec php-fpm7.4 -F


----- correia
FROM alpine:3.14

RUN apk add --no-cache php7 php7-fpm php7-mysqli php7-phar \
php7-json php7-mbstring

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

COPY ./tools/setup.sh /
RUN chmod +x /setup.sh
COPY ./conf/php-fpm.conf /etc/php7/php-fpm.d/

ENTRYPOINT ["/setup.sh"]



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