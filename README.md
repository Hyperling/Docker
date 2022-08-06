# My Docker Setup
Decided to organize and script my way into the Docker world.
Was unable to find a good tutorial on using and managing containers so this is what made sense to me based on Docker-Compose.

## How To Use
`git clone https://github.com/hyperling/docker /opt/Docker`

## Folders

### Config
Compose projects are set up here. Each folder should have a docker-compose.yml file set up.

### Volumes
The data of the files go here if the Config is done correctly.
I think this should be easier to remember than /var/lib/docker/volumes when it comes time for migrations.
Hopefully all that's needed is to rsync /opt/Docker and run start.sh on the new server.
That's my opinion though, if someone else uses this then they can use /var/.

### bin
Scripts to help make life easier. Some are pretty basic, but others do nice things like handle the container IDs.
* install.sh : Install dependencies on a new server with apt.
* create.sh : Create a new folder with the needed yml file.
* start.sh : Start all compose containers.
* stop.sh : Stop all compose containers.
* get_logs.sh : Create log files rather than using the `docker log` command or searching in /var/whatever.
