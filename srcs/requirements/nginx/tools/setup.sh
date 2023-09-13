#!/bin/sh

# Generate SSL/TLS certificate and key using OpenSSL
openssl req -new -newkey rsa:2048 \
            -days 365 \
            -nodes -x509 -keyout "$KEY_PATH" -out "$CERT_PATH" \
            -subj "/C=US/ST=State/L=City/ O=Organization/CN=gusousa.42.fr" \
            -passout pass:"123"

exec nginx
