# 2022-10-29 Hyperling
# Create website in node container and run it.

# Using Debian testing so that we use PHP >8. Otherwise the shebangs from
# the include files (#!/usr/bin/php) show up on the website.
FROM debian:testing

# Install Dependencies
RUN apt update && apt install -y sudo php-fpm nodejs npm

# Copy Static Content
RUN rm -rfv files
COPY ./files files
RUN rm -rfv files/README*

# Run Website
CMD rm -rfv www && \
    git clone https://github.com/Hyperling/www www && \
    rm -rfv www/files && \
    mv -v files www/ && \
    cd www && \
    ./run.sh
