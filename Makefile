.ONESHELL:
SHELL = /usr/bin/bash

SITES_ENABLED = /etc/nginx/sites-enabled/

payserver : deps
	# set parameters to run btcpay-setup.sh
	export BTCPAY_HOST="pay.aceitchecripto.com"
	export REVERSEPROXY_DEFAULT_HOST="pay.aceitchecripto.com"
	export REVERSEPROXY_HTTP_PORT=10080
	export NBITCOIN_NETWORK="mainnet"
	export BTCPAYGEN_CRYPTO1="btc"
	export BTCPAYGEN_CRYPTO2="xmr"
	export BTCPAYGEN_ADDITIONAL_FRAGMENTS="opt-save-storage-s"
	export BTCPAYGEN_REVERSEPROXY="nginx"
	export BTCPAYGEN_LIGHTNING="clightning"
	export BTCPAY_ENABLE_SSH=true
	export BTCPAYGEN_EXCLUDE_FRAGMENTS="nginx-https"
	# clone the BPS repo and run setup
	test ! -d btcpayserver-docker && git clone https://github.com/btcpayserver/btcpayserver-docker || true
	cd btcpayserver-docker
	git pull
	. ./btcpay-setup.sh -i
	cd ..

deps :
	apt install -y docker docker-compose git openssl

localhost_ssl : 
	openssl req -x509 -nodes -days 1024 -newkey rsa:2048 \
		-extensions 'v3_req' -config nginx/ssl/openssl.conf \
		-keyout nginx/aceitchecripto.com/ssl/key.pem \
		-out nginx/aceitchecripto.com/ssl/crt.pem 
	openssl dhparam -out nginx/ssl/dhparams.pem 2048
	cp -r nginx/aceitchecripto.com/ssl nginx/pay.aceitchecripto.com/