FROM debian:bullseye

RUN apt update \
&& apt install -y mariadb-server

RUN mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

COPY conf/mariadb-server.cnf	/etc/mysql/mariadb.conf.d/mariadb-server.cnf

COPY ./tools/setup.sh /usr/local/bin/
ENTRYPOINT ["/bin/sh", "setup.sh"]
