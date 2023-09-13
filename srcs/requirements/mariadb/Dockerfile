FROM alpine:3.17

RUN apk add --no-cache mariadb mariadb-client

RUN mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

COPY ./tools/setup.sh /
COPY ./conf/mariadb-server.cnf /etc/my.cnf.d/

RUN chown root:root /setup.sh
RUN chmod +x /setup.sh
ENTRYPOINT ["/setup.sh"]