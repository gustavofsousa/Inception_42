FROM debian:bullseye

RUN apt update -y \
    && apt upgrade \
    && apt install php-fpm php-mysql -y \
    && apt install wget -y \
    && apt install mariadb-client -y

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp


COPY ./tools/setup.sh /
COPY ./conf/www.conf /etc/php7/php-fpm.d/

ENTRYPOINT ["/setup.sh"]
