#!/usr/bin/env bash
# 2024-01-29 Hyperling
# Example of how to pull the polled Backip.zip file. This would be placed on
# the machine holding the backups in the directory that it should land.

DIR="$(dirname -- "${BASH_SOURCE[0]}")"
PROG="$(basename -- "${BASH_SOURCE[0]}")"
echo "$DIR/$PROG"

## Variables ##

DATE="`date '+%Y%m%d'`"
NEWFILE="$DIR/Backup_${DATE}.zip"
LATEST="`ls $DIR/Backup_*.zip | sort -r | head -n 1`"

## Main ##

echo "`date` - Creating '$NEWFILE'."
scp -P 4022 user@example.com:/tmp/Backup.zip $NEWFILE.tmp
mv -v $NEWFILE.tmp $NEWFILE

## Validation ##

# TBD: Can make this fancier, such as doing a real comparison for size growth.

echo "`date` - New backup's size:"
du -h $NEWFILE

echo "`date` - Previous backup's size:"
du -h $LATEST

## Finish ##

exit 0
