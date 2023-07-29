# 2023-07-29
#
# Create a Debian container which runs dnsmasq.
# https://wiki.debian.org/dnsmasq
# https://computingforgeeks.com/run-and-use-dnsmasq-in-docker-container/?expand_article=1
#

FROM debian

# Install Dependencies
RUN apt-get update && apt-get install -y dnsmasq vim inetutils-ping

# Copy Configuration Files
RUN mkdir -pv /etc/dnsmasq
COPY ./config/hosts        /etc/dnsmasq/hosts
COPY ./config/resolv.conf  /etc/dnsmasq/resolv.conf
COPY ./config/dnsmasq.conf /etc/dnsmasq/dnsmasq.conf

# Stop Default Service
RUN service dnsmasq stop

# Load Specific Config Files
CMD dnsmasq -k --log-facility=- --log-queries=extra \
      --conf-file=/etc/dnsmasq/dnsmasq.conf \
      --no-hosts --addn-hosts=/etc/dnsmasq/hosts \
      --resolv-file=/etc/dnsmasq/resolv.conf
