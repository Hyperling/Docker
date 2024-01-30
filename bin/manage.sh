#!/bin/bash
# 2023-08-26 Hyperling
# Combine all programs which loop over Config into one which takes parameters.

## Setup ##

DIR="$(dirname -- "${BASH_SOURCE[0]}")"
PROG="$(basename -- "${BASH_SOURCE[0]}")"
source $DIR/../source.env

## Functions ##

function usage() {
	# Function to give the usage of the program.
	# Parameters:
	#   1) The exit code used when leaving.
	exit_code=$1
	echo ""
	echo -n "Usage: $PROG [-A ( -u | -d | -b | -p | -c | -s )] " 1>&2
	echo "[-i CONTAINER] [-l CONTAINER] [-h]" 1>&2
	cat <<- EOF

		Manage all docker compose subprojects based on parameters. If no
		options are given then 'docker ps' is performed and the program exits.

		Parameters - Standalone:

		  (ALL)
		    -A : Equivalent of specifying '-udbpcs' for a full upgrade service.

		  (UP)
		    -u : Start all containers with 'up -d'.

		  (DOWN)
		    -d : Stop and take down all containers with 'down'.

		  (BUILD)
		    -b : Do a 'build' for containers with a 'Dockerfile'.

		  (PULL)
		    -p : Update all containers with 'pull'.

		  (CLEAN)
		    -c : Remove any abandoned Docker objects using the 'prune' commands.

		  (STATS)
		    -s : Tune in to the 'stats' of how each container is running.

		Parameters - Specifying CONTAINER:
		  Variable can be either the container ID or container name. If (UP) is
		  also provided then the container does not need to be active, otherwise
		  the container must be running so that it can be accessed.

		  (INTERACT)
		    -i CONTAINER : Remote into CONTAINER with 'exec -it CONTAINER sh'.

		  (LOGS)
		    -l CONTAINER : Follow the logs of CONTAINER with 'logs -f CONTAINER'.

		Parameters - Other:

		  (HELP)
		    -h : Display this message.

	EOF
	exit $exit_code
}

function check_container() {
	# Ensure a container which will be accessed is either running or starting.
	# Parameters:
	#   1) CONTAINER, either as ID or Name.
	#   2) WHy the container is being checked.
	container_to_check="$1"
	reason_to_check="$2"

	exists=`docker ps | grep -c $container_to_check`
	if [[ ( $exists == 0 && -z $up ) || ( -n $down && -z $up ) ]]; then
		echo -n "ERROR: $container_to_check was requested for " 1>&2
		echo "$reason_to_check but it is not up or going to be up." 1>&2
		exit 2
	fi

	return
}

## Parameters ##

while getopts ':Audbpcsi:l:h' opt; do
	case $opt in
		A) all="Y" ;;
		u) up="Y" ;;
		d) down="Y" ;;
		b) build="Y" ;;
		p) pull="Y" ;;
		c) clean="Y" ;;
		s) stats="Y" ;;
		i) interact="$OPTARG" ;;
		l) logs="$OPTARG" ;;
		h) usage 0 ;;
		*) echo "ERROR: Parameter '$OPTARG' not recognized." 1>&2 && usage 1 ;;
	esac
done

# This is done outside the getopts for readability.
if [[ -n $all ]]; then
	up="Y"; down="Y"; build="Y"; pull="Y"; clean="Y"; stats="Y"
fi

## Validations ##

# Script will behave poorly if not run with admin privileges.
if [[ $LOGNAME != "root" ]]; then
	echo    "*************************************************************"
	echo    "WARNING: Script is intended for root. Please su or sudo/doas."
	echo -e "*************************************************************\n"
fi

# Options which only work if the container exists or is going to be started.
if [[ -n $interact ]]; then
	check_container $interact interaction
fi
if [[ -n $logs ]]; then
	check_container $logs logs
fi

## Main ##

# If no parameters are passed, list all the containers which are running.
if [[ -z $up && -z $down && -z $build && -z $pull && -z $clean
	&& -z $interact && -z $logs && -z $stats
]]; then
	docker ps
	exit 0
fi

# Otherwise, loop through all the subproject configurations.
if [[ -n $up || -n $down || -n $build || -n $pull ]]; then
	cd $DOCKER_HOME/Config
	for dir in `ls`; do
		# If this is a directory, enter it, otherwise skip to the next listing.
		[ -d $dir ] && cd $dir || continue
		echo ""
		pwd

		# Ensure .env files exist so that all compose variables are populated.
		if [[ -e ./env.standard && ! -e ./.env ]]; then
			echo "WARNING: .env file was not found, copying standard as placeholder."
			cp -v env.standard .env
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

# Clean every type of Docker object which can be abandoined by Compose.
if [[ -n $clean ]]; then
	echo -e "\n*** Cleaning Abandoned Objects ***"
	docker system df
	docker image prune -a
	docker container prune
	docker volume prune
	docker network prune
	docker builder prune -a
	docker system df
fi

# Follow the logs of a container.
if [[ -n $logs ]]; then
	echo -e "\n*** Following Logs of $logs ***"
	docker logs -f $logs
fi

# Watch a top-level performance and resource monitor.
if [[ -n $stats ]]; then
	echo -e "\n*** Tuning Into Stats ***"
	docker stats
fi

exit 0
