#!/bin/sh

echo "start nginx"

if [ ! -d "/var/lib/mysql/$DB_NAME" ]; then
	mysqld_safe --datadir=/var/lib/mysql &
	sleep 1

    mysql -e "CREATE DATABASE $DB_NAME;"
    mysql -e "CREATE USER $DB_USER@'%' IDENTIFIED BY '$DB_PASSWORD';"
    mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@'%';"
    mysql -e "FLUSH PRIVILEGES;"

    mysqladmin -u root shutdown
fi

echo "All done"
exec mysqld_safe --bind-address=0.0.0.0