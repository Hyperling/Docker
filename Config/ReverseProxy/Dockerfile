# 2022-10-05 Hyperling
# Create the nginx environment for a reverse proxy.
# https://docs.docker.com/engine/reference/builder/

FROM nginx

## Configuration Files ##
# Clear old configurations.
RUN rm -rfv /etc/nginx/conf.d
# Add all the configuration files to the environment.
COPY ./config/nginx.conf /etc/nginx/nginx.conf
COPY ./config/conf.d /etc/nginx/conf.d
RUN rm -rfv /etc/nginx/conf.d/README*

## Hosted Sites ##
# Clear old sites.
RUN rm -rfv /etc/nginx/html
# Add any static HTML websites.
COPY ./config/html /etc/nginx/html
RUN rm -rfv /etc/nginx/html/README*

## Upstream Hosts ##
RUN rm -rfv /etc/nginx/hosts
COPY ./config/hosts /etc/nginx/hosts
RUN rm -rfv /etc/nginx/hosts/README*

## Load Balancing and Host-Based Port Forwarding ##
RUN rm -rfv /etc/nginx/load.conf.d
COPY ./config/load.conf.d /etc/nginx/load.conf.d
RUN rm -rfv /etc/nginx/load.conf.d/README*

