#!/bin/sh

echo "check if it already exist"
if [ ! -f "$WORDPRESS_DIR/wp-config.php" ]; then
    # Download and extract WordPress
    echo "ready to install"
    wp core download --path="$WORDPRESS_DIR" --allow-root
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
    wp core install --url="$DOMAIN_NAME" --title="$SITE_TITLE" \
        --admin_user="$ADMIN_USER" --admin_password="$ADMIN_PASSWORD" \
        --admin_email="$ADMIN_EMAIL" --skip-email --allow-root

    # Create WordPress users
    wp user create "$EDITOR_USER" "$EDITOR_EMAIL" --role='editor' --user_pass="$EDITOR_PASSWORD" --allow-root
    wp user create "$SUBSCRIBER_USER" "$SUBSCRIBER_EMAIL" --role='subscriber' --user_pass="$SUBSCRIBER_PASSWORD" --allow-root

    echo "all set done in wordpress"
fi

echo "Leaving"

# Set appropriate permissions
chmod -R 777 "$WORDPRESS_DIR"
mkdir -p /run/php/
chown www-data:www-data /run/php/

# Start PHP-FPM
exec php-fpm7.4 -F