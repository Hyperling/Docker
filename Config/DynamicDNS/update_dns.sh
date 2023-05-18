#!/bin/bash
# 2023-05-18 Hyperling
# Keep afraid.org dynamic DNS synced on ISPs do not stay static.

## Setup ##

DIR=`dirname $0`
PROG=`basename $0`
if [[ $DIR == "."* ]]; then
	DIR=`pwd`
fi
KEYFILE=private.key

## Functions ##

function usage {
	echo "Usage: $PROG [-h]" 1>&2
	cat <<- EOF
	   Program reads the local $KEYFILE and syncs with the Dynamic DNS provider.

	   Current DNS providers are mentioned in the README, but initally only 
	      afraid.org is being supported since that is the maintainer's primary
	      usage. More may be added eventually or you're welcome to contribute.
	EOF
	exit 1
}

function check {
	# Accepts parameter of status and whether the program should quit.
	status=$1
	quit=$2
	if [[ $status != 0 ]]; then
		echo "ERROR: Did not receive a successful return message, got $status." 1>&2
		if [[ $quit == "Y" ]]; then
			exit $status
		fi
	fi
	echo "Status $status is acceptable."
}

## Validations ##

# Ensure the account key is present and has contents.
if [[ ! -s $DIR/$KEYFILE ]]; then
	echo "ERROR: Key file does not exist, please see README for instructions." 1>&2
	usage
fi

## Parameters ##

# TBD 4,6,h

## Main ##

# Get the user's key
key=`cat $DIR/$KEYFILE`

# Remove any special characters like newlines
key=`echo $key`

# Ensure we got a value
if [[ key == "" ]]; then
	echo "ERROR: Key file has data but key could not be found." 1>&2
	usage
fi

# Connect with the provider.
if [[ $v4 == "Y" ]]; then
	curl https://sync.afraid.org/u/$key/
	check $? Y
fi
if [[ $v6 == "Y" ]]; then
	curl https://v6.sync.afraid.org/u/$key/
	check $? N
fi

exit

