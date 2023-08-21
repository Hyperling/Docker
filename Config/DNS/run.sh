#!/bin/bash
#
# 2023-07-29
# Config/DNS/run.sh
# Fix common issues when trying to run this container.

function stop-service {
	service=""
	if [[ -n $1 ]]; then
		service=$1
	else
		echo "ERROR: A parameter was not provided for stop-service, aborting." >&2
		exit 1
	fi
	if [[ -n $2 ]]; then
		echo "ERROR: A second parameter to stop-service is not expected, aborting." >&2
		exit 1
	fi
	systemctl disable --now $service &&
		echo "$service stopped successfully!" ||
		echo "* If $service was not found then there is no problem."
}

## Validations ##

# Ensure the necessary config files have been created.
if [[ ! -s ./config/hosts
	|| ! -s ./config/resolv.conf
	|| ! -s ./config/dnsmasq.conf
]]; then
	echo "ERROR: Please ensure all 3 files have been created in the config folder." >&2
	exit 1
fi

echo -e "\n*** Turn off any local DNS programs ***"
# These programs use port 53 but this container needs to be able to listen on it.
stop-service systemd-resolved
stop-service dnsmasq

echo -e "\n*** Create a working DNS file ***"
# Allows the domains needed during the docker pull/build to be accessed.
if [[ ! -e /etc/resolv.conf.save ]]; then
	# Save the existing file if a backup does not already exist.
	mv /etc/resolv.conf /etc/resolv.conf.save
fi
echo "nameserver 1.1.1.1" > /etc/resolv.conf

echo -e "\n*** Start the docker container ***"
docker compose down
docker compose build
docker compose up -d

echo -e "\n*** Now use the local process for DNS ***\n/etc/resolv.conf:"
echo "nameserver 127.0.0.1" > /etc/resolv.conf
echo "nameserver 127.0.1.1" >> /etc/resolv.conf
cat /etc/resolv.conf

# Finish
echo " "
exit 0
