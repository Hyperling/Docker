#!/bin/bash
# 2022-08-05 Hyperling
# Stop all containers.
# usage: stop.sh

source /opt/Docker/source.env

cd $DOCKER_HOME/Config
for dir in `ls`; do
  [ -d $dir ] && cd $dir || continue
  pwd
  [ -e docker-compose.yml ] && docker compose down
  cd ..
done

exit 0

