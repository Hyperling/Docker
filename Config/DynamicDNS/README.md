# Dynamic DNS Updater

This script is meant to be added to cron if you are using afraid.org as your dynamic DNS provider.

Similar may be possible with sites such as dyn.org or noip.com but are currently not supported.

## Instructions

Install this git project.

Add your key to Config/DynamicDNS/private.key

Add this line to the system's cron scheduling using a command like `crontab -e`.

```
5 * * * * /path_to_project/Config/DynamicDNS/update_dns.sh
```
