server {
    root /var/www/html/aceitchecripto.com;
    index src/consult.html;

    server_name consult.aceitchecripto.com;

    location /img/ {
    }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/consult.aceitchecripto.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/consult.aceitchecripto.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

    #ssl_certificate /etc/ssl/certs/localhost.crt;
    #ssl_certificate_key /etc/ssl/private/localhost.key;
}

server {

    if ($host = aceitchecripto.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot

        listen 80;
        server_name consult.aceitchecripto.com;
}