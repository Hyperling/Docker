#!/bin/bash
# 2024-01-24 Hyperling
# Commands to purge space from both Nextcloud and its database.

## Setup ##

DIR="$(dirname -- "${BASH_SOURCE[0]}")"
PROG="$(basename -- "${BASH_SOURCE[0]}")"
source $DIR/.env

## Main ##

echo -e "\n*** Files ***\n"

echo "`date` - Scanning Files"
time docker exec -itu www-data nc-app ./occ files:scan --all

echo "`date` - Cleaning Files"
time docker exec -itu www-data nc-app ./occ files:cleanup

echo -e "\n*** Database ***\n"

echo "`date` - Enabling maintenance mode to avoid any DB issues."
docker exec -itu www-data nc-app ./occ maintenance:mode --on

# https://mariadb.com/kb/en/mariadb-check/

echo "`date` - Checking DB Tables"
time docker exec -it nc-db mariadb-check \
	-Ac --user="$MYSQL_USER" --password="$MYSQL_PASSWORD"

echo "`date` - Analyzing DB Tables"
time docker exec -it nc-db mariadb-check \
	-Aa --user="$MYSQL_USER" --password="$MYSQL_PASSWORD"

echo "`date` - Optimizing DB Tables -- May take quite some time!!"
time docker exec -itu www-data nc-db mariadb-check \
	-Ao --user="$MYSQL_USER" --password="$MYSQL_PASSWORD"

# Purge Spreed Messages?

# Purge File Cache?

# Purge Anything Else?

echo "`date` - Disabling maintenance mode."
docker exec -itu www-data nc-app ./occ maintenance:mode --off

exit 0
