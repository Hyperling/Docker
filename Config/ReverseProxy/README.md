# Initial Setup Instructions
How to first begin using this subproject.
1. Move to the directory of this README.
    ```
    $ cd $DOCKER_HOME/Config/ReverseProxy
    ```
1. Add configuration files to `./config/conf.d/` which are named based on the domains and subdomains they point to.
1. Run the placeholder certificate program.
    ```
    # ./create_placeholder_certs.sh
    ```
1. Make any personal changes to `./config/nginx.conf`.
1. Build the project.
    ```
    # docker compose build
    ```
1. Start the project.
    ```
    # docker compose up -d
    ```
1. Verify it started correctly, no configuration file errors.
    ```
    # docker logs reverseproxy-app-1
    # docker logs reverseproxy-certbot-1
    ```

## DO NOT
* Edit any configurations or website data inside the container. It is destroyed on each build
    * Instead, modify the files in `./config/` then use the Update Config commands below.
* Install any additional software inside of the container. It will not persist a down and up.
    * Instead, add what is needed to the `docker-compose.yml` or `Dockerfile` to be done on each rebuild.
    * Alternatively write a script such as `../Nextcloud/fixes.ksh` which is run after every upgrade.

# Other Commands
Tasks which will also likely come up while using this subproject.

## Stop
If you need to halt the system you may use either stop or down.
```
# docker compose stop
# docker compose down
```

## Upgrade
Upgrading the containers should be as easy as this:
```
# docker compose down
# docker compose pull
# docker compose build
# docker compose up -d
```

## Update Config
Replace the configuration based on any new, updated, or removed files.
This may be possible to do when the system is up, but the best results have come from going down and back up.
This is essentially an upgrade but there is no pull.
```
# docker compose down
# docker compose build
# docker compose up -d
```
If you'd like it as a one-line command:
```
# docker compose down && docker compose build && docker compose up -d
```
