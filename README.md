# My Docker Setup
Scripting my way into the Docker world. I was unable to find a good tutorial on
using and managing containers so this is what made sense to me based on practice
with `docker-compose`. I am still new-ish to Docker and am likely to make
mistakes, but you're welcome to learn with me. ;)

## Disclaimer
Currently the project only focuses on `apt` based operating systems.

## Other README's
Each `./Config/PROJECT/` folder also contains its own README file with specific
information to running that sub project. This file's job is to cover the general
Docker installation. The others then contain details on their program setup.

## How To Use
Most of these commands benefit from being root. Something like a `sudo su -` if
you feel comfortable with it. Otherwise be aware that using sudo may cause file
permission conflicts when interacting with the configuration files and folders.

Install the project dependencies.
```
apt install git bash
```

Clone the project. You may choose anywhere, but `/opt/Docker` is recommended.
```
git clone https://github.com/hyperling/docker /opt/Docker
```

Load the environment variables.
```
source /opt/Docker/source.env
```

Install docker to the system using the official repos.
```
install.sh
```

Create an area to add a new product.
```
create.sh PROJECT_NAME
```

Edit the project's details.
```
vi /opt/Docker/Config/PROJECT_NAME/docker-compose.yml
```

Start all of the docker projects.
```
start.sh
```

Cross your fingers and hope to profit!

## Folders

### Config
Compose projects are set up here. Each folder should have a `docker-compose.yml`
file set up.

### Volumes
The data of the files go here if the Config is done correctly. I think this
should be easier to remember than `/var/lib/docker/volumes` when it comes time
for migrations. Hopefully all that'd be needed is to rsync `/opt/Docker` and run
`install.sh` and then `start.sh` on the new server. You are welcome to use a
directory other than `/opt/Docker`, this project is location agnostic.

### bin
Scripts to help make life easier. Some are pretty basic, but others do nice
things like handle the container IDs.
* `install.sh` : Install dependencies on a new server with apt.
* `create.sh` : Create a new folder with the needed yml file.
* `start.sh` : Start all compose containers.
* `stop.sh` : Stop all compose containers.
* `get_logs.sh` : Create log files rather than using the `docker log` command or
    searching in /var/whatever.
* `uninstall.sh` : If something goes wrong and you'd like to start from scratch
    without provisioning a new server then this should do the job.
