#!/bin/bash
# 2024-01-24 Hyperling
# Commands to purge space from both Nextcloud and its database.

## Setup ##

DIR="$(dirname -- "${BASH_SOURCE[0]}")"
PROG="$(basename -- "${BASH_SOURCE[0]}")"
source $DIR/.env
source $DIR/../../source.env

## Main ##

echo -e "\n*** Files ***"

# Files commands only work during normal operations.
echo -e "\n`date` - Disable Maintenance Mode."
docker exec -itu www-data nc-app ./occ maintenance:mode --off

echo -e "\n`date` - Scanning Files"
time docker exec -itu www-data nc-app ./occ files:scan --all

echo -e "\n`date` - Clean Files"
time docker exec -itu www-data nc-app ./occ files:cleanup

echo -e "\n`date` - Clean Versions"
time docker exec -itu www-data nc-app ./occ files:cleanup

echo -e "\n`date` - Clean Trash"
time docker exec -itu www-data nc-app ./occ trashbin:cleanup --all-users

echo -e "\n`date` - Trash Previews"
rm -rfv $DOCKER_HOME/Volumes/Nextcloud/nextcloud/data/appdata_*/preview/*

echo -e "\n*** Database ***"

# Prevent any catastrophic collisions.
echo -e "\n`date` - Enable Maintenance Mode"
docker exec -itu www-data nc-app ./occ maintenance:mode --on

echo -e "\n`date` - Delete Preview Records"
docker exec -itu www-data nc-db /bin/bash -c \
	"echo 'delete from oc_filecache where path like \"appdata_%/preview/%\";' | \
	mysql --user=\"$MYSQL_USER\" --password=\"$MYSQL_PASSWORD\" $MYSQL_DATABASE"

# https://mariadb.com/kb/en/mariadb-check/

echo -e "\n`date` - Checking DB Tables"
time docker exec -it nc-db mariadb-check \
	-Ac --user="$MYSQL_USER" --password="$MYSQL_PASSWORD"

echo -e "\n`date` - Analyzing DB Tables"
time docker exec -it nc-db mariadb-check \
	-Aa --user="$MYSQL_USER" --password="$MYSQL_PASSWORD"

echo -e "\n`date` - Optimizing DB Tables -- May take some time!!"
time docker exec -itu www-data nc-db mariadb-check \
	-Ao --user="$MYSQL_USER" --password="$MYSQL_PASSWORD"

# Purge Spreed Messages?

# Purge Anything Else?

# Return to normal.
echo -e "\n`date` - Disable Maintenance Mode."
docker exec -itu www-data nc-app ./occ maintenance:mode --off

exit 0
