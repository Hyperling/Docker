#!/bin/bash
# 2022-08-05 Hyperling
# Install docker from official repository. Currently only supports apt.
# Original comands came from here: https://docs.docker.com/engine/install/debian/
# usage: install.sh

## Variables ##

os=`grep ^'NAME=' /etc/os-release`
pkgmgr=""

## Validations ##

if [[ "$os" == *"Debian"* ]]; then
	repo="debian"
	pkgmgr="apt"
elif [[ "$os" == *"Ubuntu"* ]]; then
	repo="ubuntu"
	pkgmgr="apt"
else
	echo "Distribution not yet supported." &&
	exit 1
fi
echo "os=$os"
echo "repo=$repo"
echo "pkgmgr=$pkgmgr"

## Main ##

if [[ "$pkgmgr" == "apt" ]]; then
	apt purge docker docker-engine docker.io containerd runc

	apt update &&
	apt install -y ca-certificates curl gnupg lsb-release &&
	mkdir -p /etc/apt/keyrings &&
	curl -fsSL https://download.docker.com/linux/$repo/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg &&
	echo \
		"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$repo \
		$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null &&
	apt update &&
	apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin &&

	echo "Success!" &&
	exit 0
fi

## Error ##

echo "ERROR: Installation failed!"
exit 1
