ONESHELL:
.SHELL := /bin/bash

deps :
	apt install -y fail2ban ufw git nginx

website : nginx deps
	# alocate repo files in host fs
	test ! -d /var/www/html/aceitchecripto.com/ && mkdir -p /var/www/html/aceitchecripto.com/
	cp -f index.html /var/www/html/aceitchecripto.com/
	cp -f nginx/aceitchecripto.com /etc/nginx/sites-enabled/
	cp -f nginx/pay.aceitchecripto.com  /etc/nginx/sites-enabled/
	cp -f nginx/nginx.conf /etc/nginx/
	service nginx reload

payserver : btcpay deps
	# Set parameters to run btcpay-setup.sh
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
	# Clone the BPS repo and run setup
	test -d btcpayserver-docker && rm -rf btcpayserver-docker
	git clone https://github.com/btcpayserver/btcpayserver-docker
	cd btcpayserver-docker
	. ./btcpay-setup.sh -i
	cd ..

install : website payserver
