.ONESHELL:
SHELL = /usr/bin/bash

WEBSITE_CONTENT = /var/www/html/aceitchecripto.com/
SITES_ENABLED = /etc/nginx/sites-enabled/

deps :
	apt install -y fail2ban ufw git nginx openssl

localhost_certs : 
	openssl req -x509 -nodes -days 1024 -newkey rsa:2048 \
		-extensions 'v3_req' -config nginx/fakessl.conf \
		-keyout /etc/ssl/private/localhost.key \
		-out /etc/ssl/certs/localhost.crt

website : nginx deps
	# alocate repo files in host fs
	test ! -d "$(WEBSITE_CONTENT)" && mkdir -p "$(WEBSITE_CONTENT)" || true
	cp -rf src "$(WEBSITE_CONTENT)"
	cp -rf img "$(WEBSITE_CONTENT)"
	cp -f nginx/aceitchecripto.com "$(SITES_ENABLED)"
	cp -f nginx/consult.aceitchecripto.com "$(SITES_ENABLED)"
	service nginx reload

payserver : deps
	# alocate repo files in host fs
	cp -f nginx/pay.aceitchecripto.com "$(SITES_ENABLED)"
	cp -f nginx/nginx.conf /etc/nginx/
	service nginx reload
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

install : website payserver
