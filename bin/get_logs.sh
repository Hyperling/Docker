#!/bin/bash
# 2022-08-05 Hyperling
# Put active logs into files for analysis.
# usage: get_logs.sh

source /opt/Docker/source.env

dir=logs
date_format="+%Y%m%d-%H%M%S"

cd $DOCKER_HOME
mkdir -p $dir
docker ps | while read container_id image_name other; do
  image_name=${image_name##*/}
  echo $container_id $image_name
  docker inspect $container_id 1>/dev/null 2>&1 && 
    docker logs $container_id 1>${dir}/${image_name}.log.`date $date_format` 2>&1
done

chmod -R 755 $dir

exit 0

