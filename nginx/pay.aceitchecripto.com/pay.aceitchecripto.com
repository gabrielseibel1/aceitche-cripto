server {
        server_name pay.aceitchecripto.com;

        # Route everything to the real BTCPay server
        location / {

                # URL of BTCPay Server (i.e. a Docker installation with REVERSEPROXY_HTTP_PORT set to 10080)
                proxy_pass http://127.0.0.1:10080;

                proxy_set_header Host $http_host;
                proxy_set_header X-Forwarded-Proto $scheme;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

                # For websockets (used by Ledger hardware wallets)
                proxy_set_header Upgrade $http_upgrade;
        }

    listen [::]:443 ssl ipv6only=on; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/pay.aceitchecripto.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/pay.aceitchecripto.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}

server {
    if ($host = pay.aceitchecripto.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot

        listen 80 ;
        listen [::]:80 ;

        server_name pay.aceitchecripto.com;
}
