#!/bin/bash
# 2022-09-25 Hyperling
# Put fixes in a file so they do not need remembered.

docker exec -it nextcloud-app-1 apt update -y
docker exec -it nextcloud-app-1 apt install -y libmagickcore-6.q16-6-extra

# 2022-10-30 More additions after moving to Nextcloud version 25.
docker exec -itu www-data nextcloud-app-1 ./occ db:add-missing-columns
docker exec -itu www-data nextcloud-app-1 ./occ db:add-missing-indices
docker exec -itu www-data nextcloud-app-1 ./occ db:add-missing-primary-keys
docker exec -itu www-data nextcloud-app-1 ./occ db:convert-filecache-bigint
docker exec -it nextcloud-app-1 chown -Rc www-data:www-data .

exit 0

