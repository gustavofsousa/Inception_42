FROM debian:bullseye

RUN apt update \
&& apt install -y mariadb-server

RUN mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

EXPOSE 3306

COPY conf/mariadb-server.cnf	/etc/my.cnf.d/
COPY ./tools/setup.sh /
RUN chmod +x /setup.sh

ENTRYPOINT ["/setup.sh"]
