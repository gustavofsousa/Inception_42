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

COPY ./conf/php-fpm.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY ./tools/setup.sh /
RUN chmod +x /setup.sh

ENTRYPOINT ["/setup.sh"]
