#!/bin/bash
# 2022-09-25 Hyperling
# Put fixes in a file so they do not need remembered.

docker exec -it nextcloud-app-1 apt update -y
docker exec -it nextcloud-app-1 apt install -y libmagickcore-6.q16-6-extra

exit 0

