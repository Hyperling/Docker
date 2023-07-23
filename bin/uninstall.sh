#!/bin/bash
# 2022-08-05 Hyperling
# Remove docker and official repository. Currently only supports apt.
# usage: uninstall.sh

apt purge -y docker-ce docker-ce-cli containerd.io docker-compose-plugin &&
rm -v /etc/apt/keyrings/docker.gpg &&
rm -v /etc/apt/sources.list.d/docker.list &&
rm -rfv /var/lib/docker

exit 0
