#!/bin/bash
# 2022-09-25 Hyperling
# Put fixes in a file so they do not need remembered.

## Setup ##

DIR="$(dirname -- "${BASH_SOURCE[0]}")"
PROG="$(basename -- "${BASH_SOURCE[0]}")"
source $DIR/../../source.env

## Main ##

echo -e "\n*** APT ***\n"
docker exec -it nc-app apt update -y
docker exec -it nc-app apt install -y sudo libmagickcore-6.q16-6-extra htop \
	iputils-ping dnsutils vim

# 2023-12-04 Make sure cron and chmod commands get run.
echo -e "\n*** CRON ***\n"
$DOCKER_HOME/Config/Nextcloud/cron.sh && echo "Success!"

# 2022-10-30 More additions after moving to Nextcloud version 25.
echo -e "\n*** DATABASE ***\n"
docker exec -itu www-data nc-app ./occ db:add-missing-columns
docker exec -itu www-data nc-app ./occ db:add-missing-indices
docker exec -itu www-data nc-app ./occ db:add-missing-primary-keys
docker exec -itu www-data nc-app ./occ db:convert-filecache-bigint

# 2023-07-02
echo -e "\n*** FILES ***\n"
# This maybe used to exist, but make sure that Files app is correct.
docker exec -itu www-data nc-app ./occ files:scan --all
# This one takes a while.
docker exec -itu www-data nc-app ./occ files:scan-app-data
# Extras? Have used the commands in the past and may help in the future.
docker exec -itu www-data nc-app ./occ maintenance:theme:update
docker exec -itu www-data nc-app ./occ maintenance:repair
# May alsp be useful but do not have much experience with them.
docker exec -itu www-data nc-app ./occ versions:cleanup
docker exec -itu www-data nc-app ./occ files:cleanup

exit 0
