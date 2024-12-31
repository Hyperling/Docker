# 2024-12-31 Hyperling
# A dummy test file since true scripts are being kept private.
# This should help anyone understand how the project is being used.

## Instructions ##
# Add this without the comment to your /etc/hosts to test that it is working,
#   YOUR_DOCKER_SERVER_IP git.example.com
# If testing locally on a workstation,
#   127.0.0.1 git.example.com
# Then to test, first start the container,
#   cd $DOCKER_HOME/Config/ReverseProxy && docker compose build && docker compose up -d
# Then from the system with the modified /etc/hosts,
#   curl --insecure git.example.com
# You should see activity in the container log as well as the contents of the
# proxied website in the terminal, NOT git.example.com. If using a browser then you
# should notice that the URL is still git.example.com but the website is correct.

# Force HTTPS
server {

    listen 80;
    server_name git.example.com;

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
    server_name git.example.com;

    # The certs being used for the website.
    ssl_certificate /etc/nginx/certs/git.example.com/fullchain.pem;
    ssl_certificate_key /etc/nginx/certs/git.example.com/privkey.pem;

    location /.well-known/acme-challenge/ {
        default_type "text/plain";
        root /etc/nginx/letsencrypt/;
    }

    # Send traffic to upstream server
    location / {
        ## General format is PROTOCOL://SERVER:PORT.
        # This server connection is managed in the 'hosts/example.com' file.
        proxy_pass http://example-git-site;
    }

}
