# My Docker Setup
Decided to organize and script my way into the Docker world.
Was unable to find a good tutorial on using and managing containers so this is what made sense to me based on Docker-Compose.

## How To Use
`git clone https://github.com/hyperling/docker /opt/Docker`

## Config
Compose projects are set up here. Each folder should have a docker-compose.yml file set up.

## Volumes
The data of the files go here if the Config is done correctly.
I think this should be easier to remember than /var/lib/docker/volumes when it comes time for migrations.
Hopefully all that's needed is to rsync /opt/Docker and run start.sh on the new server.
That's my opinion though, if someone else uses this then they can use /var/.
