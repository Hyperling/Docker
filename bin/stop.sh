#!/bin/bash
# 2022-08-05 Hyperling
# Stop all containers.
# usage: stop.sh

## Setup ##

DIR="`dirname $0`"
PROG=`basename $0`
if [[ $DIR == *"."* ]]; then
	DIR="`pwd`"
fi
if [[ -z $DOCKER_HOME ]]; then
	DOCKER_HOME="$DIR/.."
fi

## Main ##

echo "Stopping all containers."

cd $DOCKER_HOME/Config
for dir in `ls`; do
	[ -d $dir ] && cd $dir || continue
	echo ""
	pwd
	[ -e docker-compose.yml ] && docker compose down
	cd ..
done

exit 0
