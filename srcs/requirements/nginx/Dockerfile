FROM alpine:3.17

RUN apk update && apk add --no-cache nginx openssl

RUN mkdir -p /etc/nginx
COPY ./conf/nginx.conf /etc/nginx/
COPY ./tools/setup.sh  /

RUN chmod +x /setup.sh
ENTRYPOINT ["/setup.sh"]