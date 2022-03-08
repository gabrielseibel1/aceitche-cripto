FROM nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY aceitchecripto.com/aceitchecripto.com /etc/nginx/sites-enabled/aceitchecripto.com
COPY pay.aceitchecripto.com/pay.aceitchecripto.com /etc/nginx/sites-enabled/pay.aceitchecripto.com

COPY ssl/dhparams.pem /etc/letsencrypt/ssl-dhparams.pem
COPY ssl/ssl_options.conf /etc/letsencrypt/options-ssl-nginx.conf

COPY aceitchecripto.com/ssl/key.pem /etc/letsencrypt/live/aceitchecripto.com/privkey.pem
COPY aceitchecripto.com/ssl/crt.pem /etc/letsencrypt/live/aceitchecripto.com/fullchain.pem

COPY pay.aceitchecripto.com/ssl/key.pem /etc/letsencrypt/live/pay.aceitchecripto.com/privkey.pem
COPY pay.aceitchecripto.com/ssl/crt.pem /etc/letsencrypt/live/pay.aceitchecripto.com/fullchain.pem
