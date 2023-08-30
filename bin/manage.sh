#!/bin/bash
# 2023-08-26 Hyperling
# Combine all programs which loop over Config into one which takes parameters.

## TBD ##
# -l for logs.
# -c for clean.
# Delete the scripts that this has replaced.
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
	echo "Usage: $PROG [-A ( -u | -d | -b | -p | -s )] [-i CONTAINER] [-h]" 1>&2
	cat <<- EOF

		Manage all docker compose subprojects based on parameters.
		If no options are given then 'docker ps' is performed and the program exits.

		Parameters:
		  (ALL)
		    -A : Equivalent of specifying '-udbps' to restart, update, and watch all containers.

		  (UP)
		    -u : Start all containers with 'up -d'.

		  (DOWN)
		    -d : Stop and take down all containers with 'down'.

		  (BUILD)
		    -b : Do a 'build' for containers with a 'Dockerfile'.

		  (PULL)
		    -p : Update all containers with 'pull'.

		  (STATS)
		    -s : Tune in to the 'stats' of how each container is running. If INTERACT
		         is also specified, this is executed after the session has been exited.

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

while getopts ':Audbpsi:h' opt; do
	case $opt in
		A) all="Y" ;;
		u) up="Y" ;;
		d) down="Y" ;;
		b) build="Y" ;;
		p) pull="Y" ;;
		s) stats="Y" ;;
		i) interact="$OPTARG" ;;
		h) usage 0 ;;
		*) echo "ERROR: Parameter '$OPTARG' not recognized." 1>&2 && usage 1 ;;
	esac
done

if [[ -n $all ]]; then
	up="Y"; down="Y"; build="Y"; pull="Y"; stats="Y"
fi

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
if [[ -z $up && -z $down && -z $build && -z $pull && -z $interact && -z $stats ]]; then
	docker ps
	exit 0
fi

# Otherwise, loop through all the subproject configurations.
if [[ -n $up || -n $down || -n $build || -n $pull ]]; then
	cd $DOCKER_HOME/Config
	for dir in `ls`; do
		[ -d $dir ] && cd $dir || continue
		echo ""
		pwd

		# Ensure .env files exist so that all compose variables are populated.
		if [[ -e ./env.example && ! -e ./.env ]]; then
			echo "WARNING: .env file was not found, copying example as placeholder."
			cp -v env.example .env
		fi

		# Ensure all configuration files have been created.
		if [[ -d ./config ]]; then
			ls ./config/*.example 2>/dev/null | while read example; do
				real=${example//.example/}
				if [[ ! -e $real ]]; then
					echo "WARNING: $real was not found, copying $example."
					cp -v $example $real
				fi
			done
		fi

		# Shut off container.
		if [[ $down == "Y" ]]; then
			[ -e docker-compose.yml ] && docker compose down
		fi

		# Update container from remote source such as Docker Hub.
		if [[ $pull == "Y" ]]; then
			[ -e docker-compose.yml ] && docker compose pull
		fi

		# Execute commands within the container's Dockerfile.
		if [[ $build == "Y" ]]; then
			[ -e Dockerfile ] && docker compose build
		fi

		# Run the container as a daemon.
		if [[ $up == "Y" ]]; then
			[ -e docker-compose.yml ] && docker compose up -d
		fi

		cd ..
	done
fi

# Dive into a container for running ad hoc commands.
if [[ -n $interact ]]; then
	echo -e "\n*** Hopping into $interact ***"
	docker exec -it $interact sh
fi

# Watch a top-level performance and resource monitor.
if [[ -n $stats ]]; then
	docker stats
fi

exit 0
