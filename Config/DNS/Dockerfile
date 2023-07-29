# 2023-07-29
#
# Create a Debian container which runs dnsmasq.
# https://wiki.debian.org/dnsmasq
#

FROM debian

# Install Dependencies
RUN apt update && apt install -y dnsmasq

# Remove Existing Config
RUN systemctl stop dnsmasq
RUN rm -rfv /etc/{hosts,resolv.conf,dnsmasq.conf}

# Copy Configuration Files
COPY ./config/{hosts,resolv.conf,dnsmasq.conf} /etc/

# Start Container
CMD systemctl restart dnsmasq
