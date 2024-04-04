# 2022-10-29 Hyperling
# Create website in node container and run it.

# Using Debian testing so that we use PHP >8. Otherwise the shebangs from
# the include files (#!/usr/bin/php) show up on the website.
FROM node:lts-slim

# Cache System Dependencies
RUN apt-get update && apt-get install -y git php-cli

# Cache Node Dependencies
RUN mkdir -p /var/www/api
WORKDIR /var/www/api
RUN echo '{ "dependencies": { "express": "" } }' > package.json
RUN npm install

# Install + Run Website
CMD cd /var/www/api && \
    rm -rfv pages main.js run.sh && \
    git clone https://github.com/Hyperling/Website website && \
    rm -rfv website/files && \
    mv -v website/* ./ && \
    rm -rfv website && \
    echo "Starting Website" && \
    ./run.sh
