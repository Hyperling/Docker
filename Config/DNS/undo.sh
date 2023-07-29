# 2023-07-29
# Config/DNS/undo.sh
# Easy way to stop using this container.

function start-service {
	service=""
	if [[ -n $1 ]]; then
		service=$1
	else
		echo "ERROR: A parameter was not provided for start-service, aborting."
		exit 1
	fi
	if [[ -n $2 ]]; then
		echo "ERROR: A second parameter to start-service is not expected, aborting."
		exit 1
	fi
	systemctl enable --now $service &&
		echo "$service started successfully!" ||
		echo "$service was not found, no problem."
}

echo -e "\n*** Stop the docker container ***"
docker compose down

echo -en "\n*** Restore the DNS file "
if [[ -e /etc/resolv.conf.save ]]; then
	echo "from backup ***"
	cp /etc/resolv.conf.save /etc/resolv.conf
else
	echo "with Cloudflare ***"
	echo "nameserver 1.1.1.1" > /etc/resolv.conf
	echo "nameserver 1.0.0.1" >> /etc/resolv.conf
	echo "options rotate" >> /etc/resolv.conf
fi
echo "/etc/resolv.conf:"
cat /etc/resolv.conf

echo -e "\n*** Turn on any local DNS programs ***"
start-service systemd-resolved
start-service dnsmasq

# Finish
echo " "
exit 0
