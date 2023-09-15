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
1. Create the real certificates.
    ```
    # ./create_letsencrypt_certs.sh
    ```
1. Add a job to crontab for keeping the certs valid.
    ```
    # crontab -e
    X Y * * * docker exec reverseproxy-certbot-1 certbot renew
    ```

## DO NOT
* Edit any configurations or website data inside the container. It is destroyed on each build.
    * Instead, modify the files in `./config/` then use the Update Config commands below.
* Install any additional software inside of the container. It will not persist a down and up.
    * Instead, add what is needed to the `docker-compose.yml` or `Dockerfile` to be done on each rebuild.
    * Alternatively write a script such as `../Nextcloud/fixes.ksh` which is run after every upgrade.

# Other Commands
Tasks which will also likely come up while using this subproject.

## Stop
If the proxy needs turned off either stop or down may be used.
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
If wanted as a one-line command:
```
# docker compose down && docker compose build && docker compose up -d
```

## Add New Config
1. Modify your `./config/hosts/domain` file and add the resource.
1. Create the `./config/conf.d/fqdn` file as needed, using the resource.
1. (Optional) If the system needs a cert added, run the placeholder script.
1. Restart the project based on Update Config above.
1. (Optional) Now you may run the letsencrypt script for a real certificate.
1. (Optional) Run another Update Config to make sure the certs are loaded.
1. Done! If set up correctly the site should be live.
