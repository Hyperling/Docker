# 2022-10-05 Hyperling
# Move config to nginx container.
# This is because nginx image does not play well with Volumes.
# Nextcloud and MariaDB created files in their folders fine, but nginx stays empty.

FROM nginx

COPY ./config/nginx.conf /etc/nginx/nginx.conf

COPY ./config/conf.d/* /etc/nginx/conf.d/
