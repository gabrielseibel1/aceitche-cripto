.ONESHELL:
SHELL = /usr/bin/bash

SITES_ENABLED = /etc/nginx/sites-enabled/

localhost_ssl :
	openssl req -x509 -nodes -days 1024 -newkey rsa:2048 \
		-extensions 'v3_req' -config nginx/ssl/openssl.conf \
		-keyout nginx/ssl/key.pem \
		-out nginx/ssl/crt.pem
	openssl dhparam -out nginx/ssl/dhparams.pem 2048