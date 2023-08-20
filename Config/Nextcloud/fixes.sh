#!/bin/bash
# 2022-09-25 Hyperling
# Put fixes in a file so they do not need remembered.

docker exec -it nextcloud-app-1 apt update -y
docker exec -it nextcloud-app-1 apt install -y sudo libmagickcore-6.q16-6-extra htop iputils-ping dnsutils

# 2022-10-30 More additions after moving to Nextcloud version 25.
docker exec -itu www-data nextcloud-app-1 ./occ db:add-missing-columns
docker exec -itu www-data nextcloud-app-1 ./occ db:add-missing-indices
docker exec -itu www-data nextcloud-app-1 ./occ db:add-missing-primary-keys
docker exec -itu www-data nextcloud-app-1 ./occ db:convert-filecache-bigint
docker exec -it nextcloud-app-1 chown -Rc www-data:www-data .

# 2023-02-12 Just for good measure.
docker exec -itu www-data nextcloud-app-1 ./occ app:update --all

# 2023-07-02
# This maybe used to exist, but make sure that Files app is correct.
docker exec -itu www-data nextcloud-app-1 ./occ files:scan --all
# This one takes a while.
docker exec -itu www-data nextcloud-app-1 ./occ files:scan-app-data
# Extras? Have used the commands in the past and may help in the future.
docker exec -itu www-data nextcloud-app-1 ./occ maintenance:theme:update
docker exec -itu www-data nextcloud-app-1 ./occ maintenance:repair
# May alsp be useful but do not have much experience with them.
docker exec -itu www-data nextcloud-app-1 ./occ versions:cleanup
docker exec -itu www-data nextcloud-app-1 ./occ files:cleanup

exit 0
