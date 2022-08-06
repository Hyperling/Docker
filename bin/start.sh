#!/bin/bash
# 2022-08-05 Hyperling
# Start all containers.
# usage: start.sh

source /opt/Docker/source.env

cd $DOCKER_HOME/Config
for dir in `ls`; do
  [ -d $dir ] && cd $dir || continue
  pwd
  [ -e docker-compose.yml ] && docker compose up -d
  cd ..
done

exit 0

