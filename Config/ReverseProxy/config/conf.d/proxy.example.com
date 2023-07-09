# 2022-10-05 Hyperling
# A dummy test file since true scripts are being kept private.
# This should help anyone understand how the project is being used.

## Instructions ##
# Add this without the comment to your /etc/hosts to test that it is working,
#   YOUR_DOCKER_SERVER_IP proxy.example.com
# If testing locally on a workstation,
#   127.0.0.1 proxy.example.com
# Then to test, first start the container,
#   cd $DOCKER_HOME/Config/ReverseProxy && docker compose build && docker compose up -d
# Then from the system with the modified /etc/hosts,
#   curl --insecure proxy.example.com
# You should see activity in the container log as well as the contents of the
# proxied website in the terminal, NOT proxy.example.com. If using a browser then you
# should notice that the URL is still proxy.example.com but the website is correct.

# Force HTTPS
server {

    listen 80;
    server_name proxy.example.com;

    # Redirect to a more secure protocol.
    return 301 https://$host$request_uri;

}

# Serve Resource
server {

    listen 443 ssl;
    server_name proxy.example.com;

    # The certs being used for the website.
    ssl_certificate /etc/nginx/certs/proxy.example.com/fullchain.pem;
    ssl_certificate_key /etc/nginx/certs/proxy.example.com/privkey.pem;

    # Send traffic to upstream server
    location / {
        ## General format is PROTOCOL://SERVER:PORT. For example:
        #
        # If using a domain name:
        #proxy_pass http://YOUR_SERVER_NAME:8080;
        #
        # If using an IP address:
        #proxy_pass http://192.168.1.80:8080;
        #
        # If using an upstream server:
        #proxy_pass http://example-proxy-site;
        #
        # If forwarding to an external source:
        #proxy_pass https://website.name;
        #
        # Or alternatively, do it like the force of HTTPS if not your server.
        #return 301 https://website.name/$request_uri;

        # This should forward you from 'proxy.example.com' to a real site:
        proxy_pass https://hyperling.com;
    }

}
