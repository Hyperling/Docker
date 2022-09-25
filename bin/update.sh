#!/bin/bash
# 2022-09-25 Hyperling
# Script to update a docker compose image.

docker compose down 
docker compose pull &&
docker compose up -d &&
exit 0

echo "ERROR: Did not update or start correctly." &&
exit 1

