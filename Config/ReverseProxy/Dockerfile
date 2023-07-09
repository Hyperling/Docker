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
RUN rm -rfv /etc/nginx/nginx.conf/README*

## Hosted Sites ##
# Clear old sites.
RUN rm -rfv /etc/nginx/html
# Add any static HTML websites.
COPY ./config/html /etc/nginx/html
RUN rm -rfv /etc/nginx/html/README*
