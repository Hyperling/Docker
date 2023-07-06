# 2022-10-05 Hyperling
# A dummy test file since true scripts are being kept private.
# This should help anyone understand how the project is being used.

## Instructions ##
# Add this without the comment to your /etc/hosts to test that it is working,
#   YOUR_DOCKER_SERVER_IP example.com
# If testing locally on a workstation,
#   127.0.0.1 example.com
# Then to test, first start the container,
#   cd $DOCKER_HOME/Config/ReverseProxy && docker compose build && docker compose up -d
# Then from the system with the modified /etc/hosts,
#   curl --insecure example.com
# You should a blip in the log of the container as well as the contents of the
# proxied website in the terminal, NOT example.com. If using a browser then you
# should notice that the URL is still example.com but the website is correct.

# Force HTTPS
server {

    listen 80;
    server_name example.com;

    # Redirect to a more secure protocol.
    return 301 https://$host$request_uri;

}

# Serve Resource
server {

    listen 443 ssl;
    server_name example.com;

    # The certs being used for the website.
    ssl_certificate /etc/nginx/certs/example.com/cert.crt;
    ssl_certificate_key /etc/nginx/certs/example.com/cert.key;

    # Send traffic to upstream server
    location / {
        proxy_set_header X-Forwarded-Proto https;

        ## General format is PROTOCOL://SERVER:PORT. For example:
        #
        # If using a domain name:
        #proxy_pass http://YOUR_SERVER_NAME:8080;
        #
        # If using an IP address:
        #proxy_pass http://192.168.1.80:8080;
        #
        # If forwarding to an external source:
        #proxy_pass https://website.name/URI;
        #
        # Or alternatively, do it like the force of HTTPS:
        #return 301 https://website.name/URI;

        # This should forward you from 'example.com' to a real site:
        proxy_pass https://hyperling.com;
    }

}
