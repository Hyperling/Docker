#!/bin/bash
# 2023-05-18 Hyperling
# Keep afraid.org dynamic DNS synced on ISP connections without static IPs.

## Setup ##

DIR="`dirname $0`"
PROG=`basename $0`
if [[ $DIR == "."* ]]; then
	DIR="`pwd`"
fi

DOMAIN="sync.afraid.org"
KEYFILE_NAME="private.key"
KEYFILE="$DIR/$KEYFILE_NAME"

## Functions ##

function usage {
	# Accepts 1 parameter: The exit code to use.
	exit_status=$1
	echo "Usage: $PROG [-4] [-6] [-d | -t] [-v] [-h]" 1>&2
	cat <<- EOF
	   Program reads the local $KEYFILE_NAME and syncs with the Dynamic DNS provider.

	   Current DNS providers are mentioned in the README, but initally only
	      afraid.org is being supported since that is the maintainer's primary
	      usage. More may be added eventually or you're welcome to contribute.

	   Parameters:
	      -4 : Update IPV4.
	      -6 : Update IPV6.
	         * If neither 4 or 6 are provided, both are assumed as Yes.
	      -d : Perform a dry run, echoing the commands rather than doing the update.
	      -t : Test run. Alias for the dry run option above.
	      -v : Enable extra output, helpful for debugging.
	      -h : Print this list of parameters.
	EOF
	exit $exit_status
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
if [[ ! -s $KEYFILE ]]; then
	echo "ERROR: Key file is empty or does not exist, please see README for instructions." 1>&2
	usage
fi

## Parameters ##

while getopts ":46dtvh" opt; do
	case $opt in
		4)
			v4="Y"
			;;
		6)
			v6="Y"
			;;
		d | t)
			dry_run="Y"
			;;
		v)
			set -x
			;;
		h)
			usage 0
			;;
		*)
			echo "ERROR: Parameter $opt not recognized."
			usage 1
			;;
	esac
done

# If neither parameter was passed, assume both are wanted.
if [[ -z $v4 && -z $v6 ]]; then
	v4="Y"
	v6="Y"
fi

## Main ##

# Use echo instead of cURL if doing a dry/test run.
command="curl -w HTTP%{http_code}\n"
if [[ $dry_run == "Y" ]]; then
	command="echo $command"
fi

# Ensure permissions are strict.
chmod -c 600 $KEYFILE

# Get the user's key
key=`cat $KEYFILE`

# Remove any padding like newlines or trailing spaces
key=`echo $key`

# Ensure we got a value
if [[ -z $key ]]; then
	echo "ERROR: Key file not empty but key could not be found." 1>&2
	usage 1
fi

# Try to ensure the key is not going to cause a malformed link somehow.
if [[ $key == *" "* ]]; then
	echo "WARNING: Space character found in key. Is that right? Converting to %20." 1>&2
	key=${key// /%20}
fi

uri="$DOMAIN/u/$key/"

# Connect with the provider.
if [[ $v4 == "Y" ]]; then
	$command https://$uri
	check $? Y
fi
if [[ $v6 == "Y" ]]; then
	$command https://v6.$uri
	check $? N
fi

exit
