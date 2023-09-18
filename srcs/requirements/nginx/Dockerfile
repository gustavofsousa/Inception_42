FROM alpine:3.17

RUN apk update && apk add --no-cache openrc nginx openssl bash apache2

RUN rc-update add apache2

RUN mkdir -p /etc/nginx
COPY ./conf/nginx.conf /etc/nginx/
COPY ./tools/setup.sh  /

RUN chmod +x /setup.sh
ENTRYPOINT ["/setup.sh"]