SHELL := /bin/bash
.ONESHELL:

install : nginx btcpay deps
	test ! -d /var/www/html/aceitchecripto.com/ && mkdir -p /var/www/html/aceitchecripto.com/
	cp -f index.html /var/www/html/aceitchecripto.com/
	
	# alocate repo files in host fs
	cp -f nginx/aceitchecripto.com /etc/nginx/sites-enabled/
	cp -f nginx/pay.aceitchecripto.com  /etc/nginx/sites-enabled/
	cp -f nginx/nginx.conf /etc/nginx/
	service nginx reload
	# Clone the btcpay server repository
	test -d btcpayserver-docker && rm -rf btcpayserver-docker
	git clone https://github.com/btcpayserver/btcpayserver-docker
	cd btcpayserver-docker
	# Run btcpay-setup.sh with the right parameters
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
	. ./btcpay-setup.sh -i
	cd ..

deps : 
	apt install -y fail2ban ufw git nginx

