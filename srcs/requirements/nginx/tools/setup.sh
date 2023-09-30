#!/bin/sh

mkdir -p "/etc/ssl/certs/"
mkdir -p "/etc/ssl/private/"
# Generate SSL/TLS certificate and key using OpenSSL
	openssl genrsa -out $KEY_PATH 2048
	openssl req -new -x509 -key $KEY_PATH -out $CERT_PATH -days 365 -subj "/CN=$DOMAIN_NAME"

echo "SSL generated, executing nginx now"
exec nginx
