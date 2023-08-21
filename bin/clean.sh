#!/bin/bash
# 2023-08-21 Hyperling
# Clean all unused images and containers.
#   https://docs.docker.com/config/pruning/
# Very helpful during development, nice in a long-running production as well.
# usage: clean.sh

docker image prune -a

docker container prune

docker volume prune

docker network prune

exit 0
