#!/bin/sh

if [ ! -d "/var/lib/mysql/$DB_NAME" ]; then
	mysqld_safe --datadir=/var/lib/mysql &
	sleep 1

    mysql -e "CREATE DATABASE $DB_NAME;"
    mysql -e "CREATE USER $DB_USER@'%' IDENTIFIED BY '$DB_PASSWORD';"
    mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@'%';"
    mysql -e "FLUSH PRIVILEGES;"

    mysqladmin -u root shutdown
fi

exec mysqld_safe --datadir=/var/lib/mysql