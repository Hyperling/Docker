# 2023-07-29
# Create website in node container and run it.

# Using Debian testing so that we use PHP >8. Otherwise the shebangs from
# the include files (#!/usr/bin/php) show up on the website.
FROM debian:testing

# Install Dependencies
RUN apt update && apt install -y dnsmasq

# Remove Existing Config
RUN systemctl stop dnsmasq
RUN rm -rfv /etc/{hosts,resolv.conf,dnsmasq.conf}

# Copy Configuration Files
COPY ./config/{hosts,resolv.conf,dnsmasq.conf} /etc/

# Start Container
CMD systemctl restart dnsmasq
