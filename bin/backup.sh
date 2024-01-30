#!/usr/bin/env bash
# 2024-01-29 Hyperling
# Create a backup file with a generic name for polling.

DIR="$(dirname -- "${BASH_SOURCE[0]}")"
PROG="$(basename -- "${BASH_SOURCE[0]}")"
echo "$DIR/$PROG"
source $DIR/../source.env

## Variables ##

file="/tmp/Backup.zip"
time="`which time`"

## Main ##

# Remove the last backup.
if [[ -e $file ]]; then
	echo "`date` - Removing existing file."
	rm -fv $file
fi

echo -e "\n`date` - Take down services for a cold backup."
manage.sh -d

echo -e "\n`date` - Create the backup for '$DOCKER_HOME'."
cd $DOCKER_HOME
$time zip -r $file.tmp . 1>/dev/null
mv -v $file.tmp $file

echo -e "\n`date` - Done with zipping, check size."
ls -sh $file

echo -e "\n`date` - Ensure other users can access the file."
chmod -v 755 $file

echo -e "\n`date` - Bring services back up."
manage.sh -u

## Finish ##

echo -e "\n`date` - Done!"
exit 0
