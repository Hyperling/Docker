# Installation

1. Create inv.env file and populate the following values:
[TBD does this work since the var is being piped in the compose file?]
    ```
    user: kemal
    password: kemal
    domain=""
    hmac_key=""
    ```

1. Create pg.env and populate the following values:
    ```
    POSTGRES_USER:
    POSTGRES_PASSWORD:
    ```

1. Make any changes to the `docker-compose.yml` file and start it up.
    ```
    # docker compose up -d
    ```

The official instructions also suggest cloning the project first, but not sure
why. [TBD: It does not seem likethe cloning is necessary, the project starts fine.]

## Official Installation Documentation

https://docs.invidious.io/installation/

# Configuration



## Official Config Guide

https://docs.invidious.io/configuration/
