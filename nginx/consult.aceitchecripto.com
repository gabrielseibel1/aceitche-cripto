server {
    if ($host = aceitchecripto.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot

        listen 80;
        server_name consult.aceitchecripto.com;
}
