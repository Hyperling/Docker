#!/bin/bash
# 2022-09-25 Hyperling
# Put fixes in a file so they do not need remembered.

## Setup ##

DIR="$(dirname -- "${BASH_SOURCE[0]}")"
PROG="$(basename -- "${BASH_SOURCE[0]}")"
source $DIR/../../source.env

## Main ##

echo -e "\n*** APT ***\n"

echo "`date` - Update Apt Cache"
docker exec -it nc-app apt update -y

echo "`date` - Install Additonal Software"
docker exec -it nc-app apt install -y sudo libmagickcore-6.q16-6-extra htop \
	iputils-ping dnsutils vim

# 2023-12-04 Make sure cron and chmod commands get run.
echo -e "\n*** CRON ***\n"

echo "`date` - Run Cron Job"
$DOCKER_HOME/Config/Nextcloud/cron.sh && echo "Success!"

# 2022-10-30 More additions after moving to Nextcloud version 25.
echo -e "\n*** DATABASE ***\n"

echo "`date` - Add Missing Columns"
docker exec -itu www-data nc-app ./occ db:add-missing-columns

echo "`date` - Add Missing Indexes"
docker exec -itu www-data nc-app ./occ db:add-missing-indices

echo "`date` - Add Missing PKs"
docker exec -itu www-data nc-app ./occ db:add-missing-primary-keys

echo "`date` - Convert Filecache BigInt"
docker exec -itu www-data nc-app ./occ db:convert-filecache-bigint

# 2023-07-02
echo -e "\n*** FILES ***\n"

# This maybe used to exist, but make sure that Files app is correct.
echo "`date` - Scanning All Files"
docker exec -itu www-data nc-app ./occ files:scan --all

# This one takes a while.
echo "`date` - Scanning App Data"
docker exec -itu www-data nc-app ./occ files:scan-app-data

# Extras? Have used the commands in the past and may help in the future.
echo "`date` - Theme Update"
docker exec -itu www-data nc-app ./occ maintenance:theme:update
echo "`date` - Repair"
docker exec -itu www-data nc-app ./occ maintenance:repair

# May also be useful but do not have much experience with them.
echo "`date` - Clean Versions"
docker exec -itu www-data nc-app ./occ versions:cleanup
echo "`date` - Clean Files"
docker exec -itu www-data nc-app ./occ files:cleanup

exit 0
