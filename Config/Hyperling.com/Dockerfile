# 2022-10-29 Hyperling
# Create website in node container and run it.

# Using Debian testing so that we use PHP >8. Otherwise the shebangs from
# the include files (#!/usr/bin/php) show up on the website.
FROM node:lts-slim

# Install Dependencies
RUN apt update && apt install -y git php-cli

# Run Website
CMD cd /var/www/api && \
    rm -rfv pages main.js run.sh && \
    git clone https://github.com/Hyperling/Website website && \
    rm -rfv website/files && \
    mv -v website/* ./ && \
    rm -rfv website && \
    echo "Starting Website" && \
    ./run.sh
