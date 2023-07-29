# 2023-07-29
#
# Create a Debian container which runs dnsmasq.
# https://wiki.debian.org/dnsmasq
#

FROM debian

# Remove Existing Config
RUN rm -rfv /etc/{hosts,resolv.conf,dnsmasq.conf}

# Install Dependencies
RUN apt update && apt install -y dnsmasq

# Copy Configuration Files
COPY ./config/hosts        /etc/
COPY ./config/resolv.conf  /etc/
COPY ./config/dnsmasq.conf /etc/

## Reload Service
RUN service dnsmasq restart
