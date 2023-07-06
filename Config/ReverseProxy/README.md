# Setup Instructions
How to first begin using this subproject.
1. Move to this directory.
```
cd $DOCKER_HOME/Config/ReverseProxy
```
1. Run the placeholder certificate program.
```
create_placeholder_certs.sh
```
1. Build the project. This also needs done any time `./config/conf.d/*` changes.
```
docker compose build
```
1. Start the project.
```
docker compose up -d
```
1. Verify it started correctly, no configuration file errors.
```
docker compose logs reverseproxy-app-1
docker compose logs reverseproxy-certbot-1
```

# Other Commands
## Stop
If you need to halt the project you may use either stop or down.
```
docker compose stop
docker compose down
```
## Upgrade
Upgrading the applications should be as easy as this:
```
docker compose down
docker compose pull
docker compose build
docker compose up -d
```
