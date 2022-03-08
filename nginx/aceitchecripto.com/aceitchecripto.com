server {
    # Put your domain name here
    server_name aceitchecripto.com;

    location / {
        proxy_pass http://127.0.0.1:8080/;
    }

    location /pay {
        rewrite ^ https://pay.aceitchecripto.com; # TODO make this localhost-friendly?
    }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/aceitchecripto.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/aceitchecripto.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
}

server {
    if ($host = aceitchecripto.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot

    listen 80;
    server_name aceitchecripto.com;
}