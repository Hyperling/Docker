#!/bin/bash
# 2022-09-25 Hyperling
# Put fixes in a file so they do not need remembered.

## Setup ##

DIR="$(dirname -- "${BASH_SOURCE[0]}")"
PROG="$(basename -- "${BASH_SOURCE[0]}")"
source $DIR/.env
source $DIR/../../source.env

## Main ##

echo -e "\n*** APT ***"

echo -e "\n`date` - Update Apt Cache"
docker exec -it nc-app apt update -y

echo -e "\n`date` - Install Additional Software"
docker exec -it nc-app apt install -y sudo libmagickcore-6.q16-6-extra htop \
	iputils-ping dnsutils vim bzip2 libbz2-dev # php-bz2

# 20240130
# https://help.nextcloud.com/t/docker-image-setup-warning-missing-bz2-after-update-to-nc-28-0-0/176605
echo -e "\n`date` - Compile PHP Modules"
docker exec -it nc-app docker-php-ext-install bz2

# 2023-12-04 Make sure cron and chmod commands get run.
echo -e "\n*** CRON ***"

echo -e "\n`date` - Run Cron Job"
$DOCKER_HOME/Config/Nextcloud/cron.sh && echo "Success!"

# 2022-10-30 More additions after moving to Nextcloud version 25.
echo -e "\n*** DATABASE ***"

# Clear DB errors by allowing the DB to perform any incremental upgrades.
# https://jira.mariadb.org/browse/MDEV-26342
echo -e "\n`date` - mysql_upgrade"
docker exec -itu www-data nc-app ./occ maintenance:mode --on
time docker exec -it nc-db mysql_upgrade \
	-user="root" --password="$MYSQL_ROOT_PASSWORD"
docker exec -itu www-data nc-app ./occ maintenance:mode --off

echo -e "\n`date` - Add Missing Columns"
docker exec -itu www-data nc-app ./occ db:add-missing-columns

echo -e "\n`date` - Add Missing Indexes"
docker exec -itu www-data nc-app ./occ db:add-missing-indices

echo -e "\n`date` - Add Missing PKs"
docker exec -itu www-data nc-app ./occ db:add-missing-primary-keys

echo -e "\n`date` - Convert Filecache BigInt"
docker exec -itu www-data nc-app ./occ db:convert-filecache-bigint

# 2023-07-02
echo -e "\n*** FILES ***"

# This maybe used to exist, but make sure that Files app is correct.
echo -e "\n`date` - Scanning All Files"
docker exec -itu www-data nc-app ./occ files:scan --all

# This one takes a while.
echo -e "\n`date` - Scanning App Data"
docker exec -itu www-data nc-app ./occ files:scan-app-data

# Extras? Have used the commands in the past and may help in the future.
echo -e "\n`date` - Theme Update"
docker exec -itu www-data nc-app ./occ maintenance:theme:update
echo -e "\n`date` - Repair"
docker exec -itu www-data nc-app ./occ maintenance:repair

# May also be useful but do not have much experience with them.
echo -e "\n`date` - Clean Versions"
docker exec -itu www-data nc-app ./occ versions:cleanup
echo -e "\n`date` - Clean Files"
docker exec -itu www-data nc-app ./occ files:cleanup

exit 0
