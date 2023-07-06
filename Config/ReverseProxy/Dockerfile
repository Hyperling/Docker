# 2022-10-05 Hyperling
# Create the nginx environment for a reverse proxy.
# https://docs.docker.com/engine/reference/builder/

FROM nginx

# Add all the configuration files to the environment.
COPY ./config/nginx.conf /etc/nginx/nginx.conf
COPY ./config/conf.d/*.* /etc/nginx/conf.d/
