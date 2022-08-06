#!/bin/bash
# 2022-08-05 Hyperling
# Create new container template.
# usage: create.sh PROJECT_NAME

source /opt/Docker/source.env

## Validation ##

[[ -z $1 ]] && {
  echo "ERROR: A project name must be specified."
  exit 1
}

[[ ! -z $2 ]] && {
  echo "ERROR: Program does not accept a 2nd parameter. Please quote project names with spaces if you insist on using them."
  exit 2
}

## Variables ##

dir="$1"
file="$dir/docker-compose.yml"

## Main ##

cd $DOCKER_HOME
mkdir -pv "$dir"
[[ ! -f "$file" ]] && echo -e "# Comment.\nservices:\n" >> "$file" || 
  echo "File already exists, leaving contents alone."
echo "${file}:"
cat "$file"

exit 0

