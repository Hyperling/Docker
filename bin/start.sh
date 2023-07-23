#!/bin/bash
# 2022-08-05 Hyperling
# Start all containers.
# usage: start.sh

DIR="`dirname $0`"
PROG=`basename $0`
if [[ $DIR == *"."* ]]; then
	DIR="`pwd`"
fi

if [[ -z $DOCKER_HOME ]]; then
	DOCKER_HOME="$DIR/.."
fi

cd $DOCKER_HOME/Config
for dir in `ls`; do
	[ -d $dir ] && cd $dir || continue
	pwd
	[ -e Dockerfile ] && docker compose build
	[ -e docker-compose.yml ] && docker compose up -d
	cd ..
done

exit 0
