FROM nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY aceitchecripto.com /etc/nginx/sites-enabled/aceitchecripto.com

COPY ssl/dhparams.pem /etc/letsencrypt/ssl-dhparams.pem
COPY ssl/ssl_options.conf /etc/letsencrypt/options-ssl-nginx.conf

COPY ssl/key.pem /etc/letsencrypt/live/aceitchecripto.com/privkey.pem
COPY ssl/crt.pem /etc/letsencrypt/live/aceitchecripto.com/fullchain.pem
