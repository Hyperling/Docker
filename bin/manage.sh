#!/bin/bash
# 2023-08-26 Hyperling
# Combine all programs which loop over Config into one which takes parameters.

## TBD ##
# -l for logs.
# -c for clean.
# Delete the scripts that this has replaced.
# Still thinking whether to separate -b for build.
# Make it config-aware to that it creates things like .env files from examples.
###

## Setup ##

PROG="$(basename -- "${BASH_SOURCE[0]}")"
DIR="$(dirname -- "${BASH_SOURCE[0]}")"
source $DIR/../source.env

## Functions ##

function usage() {
	# Function to give the usage of the program.
	# Accepts 1 parameter for the exit code used to leave the program.
	exit_code=$1
	echo ""
	echo "Usage: $PROG [-u | -d | -p] [-i CONTAINER] [-h]" 1>&2
	cat <<- EOF

		Manage all docker compose subprojects based on parameters.
		If no options are given then 'docker ps' is performed and the program exits.

		Parameters:
		  (UP)
		    -u : Reload and start all containers with 'build' and 'up -d'.

		  (DOWN)
		    -d : Stop and take down all containers with 'down'.

		  (PULL)
		    -p : Update all containers with 'pull' and 'build'.

		  (INTERACT)
		    -i CONTAINER : Remote into CONTAINER with 'exec -it CONTAINER sh'.
		                   Variable can be either the container ID or container name.
		                   If (UP) is also provided then the container does not need
		                   to be active, otherwise the container must be running.

		  (HELP)
		    -h : Display this message.

	EOF
	exit $exit_code
}

## Parameters ##

while getopts ':udpi:h' opt; do
	case $opt in
		u) up="Y" ;;
		d) down="Y" ;;
		p) pull="Y" ;;
		i) interact="$OPTARG" ;;
		h) usage 0 ;;
		*) echo "ERROR: Parameter '$OPTARG' not recognized." 1>&2 && usage 1 ;;
	esac
done

## Validations ##

# Script will behave poorly if not run with admin privileges.
if [[ $LOGNAME != "root" ]]; then
	echo "WARNING: Script is intended for root user only. Please su or sudo/doas."
fi

# Interact will only work if the container exists or is going to be started.
if [[ -n $interact ]]; then
	exists=`docker ps | grep -c $interact`
	if [[ ( $exists == 0 && -z $up ) || ( -n $down && -z $up ) ]]; then
		echo "ERROR: $interact was requested but it either is not or will not be active." 1>&2
		exit 2
	fi
fi

## Main ##

# If no parameters are passed, list all the containers which are running.
if [[ -z $up && -z $down && -z $pull && -z $interact ]]; then
	docker ps
	exit 0
else

	# Otherwise, loop through all the subproject configurations.
	cd $DOCKER_HOME/Config
	for dir in `ls`; do
		[ -d $dir ] && cd $dir || continue
		echo ""
		pwd

		if [[ $down == "Y" ]]; then
			[ -e docker-compose.yml ] && docker compose down
		fi

		if [[ $pull == "Y" ]]; then
			[ -e docker-compose.yml ] && docker compose pull
		fi

		if [[ $pull == "Y" || $up == "Y" ]]; then
			[ -e Dockerfile ] && docker compose build
		fi

		if [[ $up == "Y" ]]; then
			[ -e docker-compose.yml ] && docker compose up -d
		fi

		cd ..
	done
fi

# Dive into a container for running ad hoc commands.
if [[ -n $interact ]]; then
	echo -e "\n** Hopping into $interact **"
	docker exec -it $interact sh
fi

exit 0
