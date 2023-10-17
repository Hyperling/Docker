#!/bin/bash
# 2023-08-25 Hyperling
# Put the cron command in a script as well as other automation.
# This should be added to root's crontab with the full path, such as:
#   */5 * * * * /opt/Docker/Config/Nextcloud/cron.ksh

# Check if a job is already going.
PROG="$(basename -- "${BASH_SOURCE[0]}")"
RUNNING=`ps -ef | grep $PROG | grep -v grep | grep -v $$ | grep -v "sh -c" | wc -l`
if (( $RUNNING > 0 )); then
	exit $RUNNING
fi

# 2023-08-25 From crontab.
sh -c "docker exec -u www-data nc-app php cron.php --define apc.enable_cli=1"

# 2023-08-25 From fixes.sh, keep ownership correct and apps up to date.
sh -c "docker exec -it nc-app chown -Rc www-data:www-data ."
# No longer update apps in advance of NC updates, allow the upgrade process to do it.
#sh -c "docker exec -itu www-data nc-app ./occ app:update --all"

exit 0
