#!/bin/bash
# Create a real cert for each file in config/conf.d/.

## Variables ##

DIR=`dirname $0`
if [[ $DIR == \.* ]]; then
	DIR=`pwd`
fi

# Where the files need to live.
CERT_DIR=$DIR/../../Volumes/ReverseProxy/letsencrypt-certs
echo "CERT_DIR=$CERT_DIR"

## Validations ##

# Ensure that fake certs were created at some point, or that the system has been run at least once.
if [[ ! -d $CERT_DIR ]]; then
	echo "ERROR: Certificate directory does not exist yet. Run the placeholder script first." >&2
	exit 1
fi

# The container needs to be running in order to use the certbot command.
certbot_running=`docker ps | grep -c reverseproxy-certbot-1`
if [[ $certbot_running != 1 ]]; then
	echo "ERROR: Certbot container does not appear to be running, cannot continue." >&2
	exit 1
fi

## Input ##

# Gather information from the user.
echo -n "Please provide the email address you would like the certs bound to: "
read email
if [[ -z $email ]]; then
	echo "ERROR: Email address is mandatory. $email" >&2
	exit 1
fi

echo -n "Please double check that '$email' looks correct and provide Yes if so: "
typeset -u confirm
read confirm
if [[ $confirm != "Y"* ]]; then
	echo "Email address was not confirmed, received '$confirm', aborting."
	exit 0
fi

## Main ##

# Loop over the proxy configuration files and ensure they have certs.
ls $DIR/config/conf.d/*.* | while read file; do
	filename=`basename $file`

	if [[ $filename == *"example.com"* ]]; then
		echo "Skipping $filename since it is only an example."
		continue
	fi

	echo "*** Checking $filename ***"
	if [[ -d $CERT_DIR/$filename ]]; then
		echo "Getting the domains which need the cert."
		domains=`grep server_name $file`

		# Clean up the data by removing the directive and semi-colon, changing
		#  spaces to commas, and making sure there are no gaps.
		domains=${domains//server_name/}
		domains=${domains//;/}
		domains=`echo $domains`
		domains=${domains// /,}
		echo "Domains='$domains'"

		echo "Attempting to create real certs at $CERT_DIR/$filename."
		docker exec reverseproxy-certbot-1 certbot certonly -n --standalone \
				--agree-tos -m $email -d $filename

		ls -lh $CERT_DIR/$filename/*
	else
		echo "Website's certificate folder does not exist, skipping."
		continue
	fi
done

exit 0
