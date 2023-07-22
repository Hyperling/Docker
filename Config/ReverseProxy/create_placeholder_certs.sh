#!/bin/bash
# Create a fake cert for each file in config/conf.d/.

## Variables ##

DIR=`dirname $0`
if [[ $DIR == \.* ]]; then
	DIR=`pwd`
fi

# Where the files need to live.
CERT_DIR=$DIR/../../Volumes/ReverseProxy/letsencrypt-certs
echo "CERT_DIR=$CERT_DIR"

## Main ##

# Create the directory if it does not exist.
mkdir -pv $CERT_DIR

# Loop over the proxy configuration files and ensure they have certs.
grep -l proxy_pass $DIR/config/conf.d/*.* | while read file; do
	filename=`basename $file`
	echo "*** Checking $filename ***"
	if [[ ! -d $CERT_DIR/$filename ]]; then
		echo "Creating self-signed certs at $CERT_DIR/$filename."
		mkdir -pv $CERT_DIR/$filename
		openssl req -new -x509 -days 3 -nodes \
				-out $CERT_DIR/$filename/fullchain.pem \
				-keyout $CERT_DIR/$filename/privkey.pem \
				-subj "/CN=$filename/O=$filename/C=XX"
		ls -lh $CERT_DIR/$filename/*
	else
		echo "Certs already exist!"
	fi
done

exit 0
