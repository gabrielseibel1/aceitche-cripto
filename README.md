# Aceitche Cripto

A website to help people and businesses accept crypto payments, [aceitchecripto.com](https://aceitchecripto.com).

## Installation

If you're a developer running this project, you can build and install it as follows:

```
sudo make deps

# run this once for local setups ssl
# copy existing ssl files to nginx folders (example)
# optionally make fake certs
make localhost_ssl
sudo cp /etc/letsencrypt/ssl-dhparams.pem nginx/ssl/dhparams.pem
sudo cp /etc/letsencrypt/options-ssl-nginx.conf nginx/ssl/ssl_options.conf
sudo cp /etc/letsencrypt/live/aceitchecripto.com/privkey.pem nginx/aceitchecripto.com/ssl/key.pem
sudo cp /etc/letsencrypt/live/aceitchecripto.com/fullchain.pem nginx/aceitchecripto.com/ssl/crt.pem
sudo cp /etc/letsencrypt/live/pay.aceitchecripto.com/privkey.pem nginx/pay.aceitchecripto.com/ssl/key.pem
sudo cp /etc/letsencrypt/live/pay.aceitchecripto.com/fullchain.pem nginx/pay.aceitchecripto.com/ssl/crt.pem

## create .env file as follows:
# ADDRESS=0.0.0.0:8081
# PG__DBNAME="..."
# PG__HOST=aceitchecripto-psql
# PG__PORT=5432
# PG__USER="..."
# PG__PASSWORD="..."
# POSTGRES_USER="..."
# POSTGRES_PASSWORD="..."

sudo docker-compose up -d --build --force-recreate
make payserver
```

