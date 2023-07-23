# Dynamic DNS Updater

This script is meant to be added to cron if you are using afraid.org as your
dynamic DNS provider. Similar may be possible with sites such as dyn.org or
noip.com but are currently not supported.

## Afraid.org Instructions

1. Install this project.

    ```
    git clone https://github.com/Hyperling/docker $PROJECT_DIR
    ```

1. Add your DNS account key to $PROJECT_DIR/Config/DynamicDNS/private.key

1. Add this line to the system's cron scheduling using a command like `crontab -e`.

    ```
    5 * * * * $PROJECT_DIR/Config/DynamicDNS/update_dns.sh
    ```

### TESTING

Please ensure all testing is done with the test or dry run flags. If you run
this for your private key outside of your network then your Dynamic DNS may
become inaccurate. This program is only intended to be run in a production
manner on the network which need the Dynamic DNS pointing towards it.

## Other Dynamic DNS Hosts

### No-IP.org Instructions

Please see this guide on installing the Dynamic Update Client (DUC).

https://my.noip.com/dynamic-dns/duc
