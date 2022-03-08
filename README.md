# Aceitche Cripto

A website to help people and businesses accept crypto payments, [aceitchecripto.com](https://aceitchecripto.com).

## Installation

If you're a developer running this project, you can build and install it as follows:

```
# run this once for local setups ssl
# copy existing ssl files to nginx folders (example)
sudo cp /etc/letsencrypt/ssl-dhparams.pem nginx/ssl/dhparams.pem
sudo cp /etc/letsencrypt/options-ssl-nginx.conf nginx/ssl/ssl_options.conf
sudo cp /etc/letsencrypt/live/aceitchecripto.com/privkey.pem nginx/ssl/key.pem
sudo cp /etc/letsencrypt/live/aceitchecripto.com/fullchain.pem nginx/ssl/cert.pem
sudo cp /etc/letsencrypt/live/pay.aceitchecripto.com/privkey.pem nginx/ssl/key.pem
sudo cp /etc/letsencrypt/live/pay.aceitchecripto.com/fullchain.pem nginx/ssl/cert.pem

# optionally make fake certs
make localhost_ssl

make docker_nginx
docker run -p 80:80 -p 443:443 -d aceitche-cripto-nginx

# run backend
cargo run

make payserver
```

