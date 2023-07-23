# 2023-07-08 Hyperling
# A dummy test file since true scripts are being kept private.
# This should help anyone understand how the project is being used.

## Instructions ##
# Add this without the comment to your /etc/hosts to test that it is working,
#   YOUR_DOCKER_SERVER_IP html.example.com
# If testing locally on a workstation,
#   127.0.0.1 html.example.com
# Then to test, first start the container,
#   cd $DOCKER_HOME/Config/ReverseProxy && docker compose build && docker compose up -d
# Then from the system with the modified /etc/hosts,
#   curl --insecure html.example.com
# You should see activity in the container log as well as the contents of the
# proxied website in the terminal, NOT html.example.com. If using a browser then you
# should notice that the URL is still html.example.com but the website is correct.

# Force HTTPS
server {

    listen 80;
    server_name html.example.com;

    location /.well-known/acme-challenge/ {
        default_type "text/plain";
        root /etc/nginx/letsencrypt/;
    }

    # Redirect to a more secure protocol.
    location / {
        return 301 https://$host$request_uri;
    }

}

# Serve Resource
server {

    listen 443 ssl;
    server_name html.example.com;

    # The certs being used for the website.
    ssl_certificate /etc/nginx/certs/html.example.com/fullchain.pem;
    ssl_certificate_key /etc/nginx/certs/html.example.com/privkey.pem;

    location /.well-known/acme-challenge/ {
        default_type "text/plain";
        root /etc/nginx/letsencrypt/;
    }

    # Load the static web content.
    location / {
        root /etc/nginx/html/html.example.com;
    }

}
