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
PREVIOUS="`ls $DIR/Backup_*.zip | sort -r | head -n 1`"

## Functions ##

function usage {
	echo -e "Usage: $PROG -d DESTINATION [-u USER] [-p PORT] [-h]\n"
	cat <<- EOF
		Download the latest Backup.zip from a Hyperling/Docker type project. The
		file is downloaded to the directory that this file exists in, so that it
		can be conveniently kept with the backups themselves.

		Parameters
		  -d : The server name or IP address running hhe Docker instance.
		  -u : Username to connect as. Default LOGNAME, currently '$LOGNAME'.
		  -p : Port to connect through. Defaults to 22.
		  -h : Display this usage text.
	EOF
}

## Parameters ##

port=22
user="$LOGNAME"
while getopts ':d:u:p:h' opt; do
	case "$opt" in
		d) destination="$OPTARG" ;;
		u) user="$OPTARG" ;;
		p) port="$OPTARG" ;;
		h) usage 0 ;;
		*) echo "ERROR: Parameter '$OPTARG' not recognized." >&2
			usage 1 ;;
	esac
done

## Validations ##

if [[ -z $destination ]]; then
	echo "ERROR: Destination was not provided." >&2
	usage 2
fi

## Main ##

echo "`date` - Creating '$NEWFILE'."
scp -P 4022 user@example.com:/tmp/Backup.zip $NEWFILE.tmp
mv -v $NEWFILE.tmp $NEWFILE

## Validation ##

# TBD: Can make this fancier, such as doing a real comparison for size growth.

echo "`date` - New backup's size:"
du -h $NEWFILE

if [[ -n $PREVIOUS ]]; then
	echo "`date` - Previous backup's size:"
	du -h $PREVIOUS
fi

## Finish ##

exit 0
