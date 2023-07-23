# Dynamic DNS Updater

This script is meant to be added to cron if you are using afraid.org as your
dynamic DNS provider. Similar may be possible with sites such as dyn.org or
noip.com but are currently not supported in this project. Links to some of these
product's self-built solutions can be found below.

## Afraid.org Version 2 Instructions

1. Install this project.

    ```
    git clone https://github.com/Hyperling/docker $PROJECT_DIR
    ```

1. Add your Afraid DNS account key to $PROJECT_DIR/Config/DynamicDNS/private.key.
The account key can be found [here](https://freedns.afraid.org/dynamic/v2/).

1. Add this line to the system's cron scheduling using a command like `crontab -e`.
The sleep waits anywhere from 0 to 55 minutes due to the [Random/10](https://tldp.org/LDP/abs/html/randomvar.html).

    ```
    @hourly sleep $(( $RANDOM / 10 )); $PROJECT_DIR/Config/DynamicDNS/update_dns.sh
    ```

### TESTING

Please ensure all testing is done with the test or dry run flags. If you run
this for your private key outside of your network then your Dynamic DNS may
become inaccurate. This program is only intended to be run in a production
manner on the network which needs the Dynamic DNS pointing towards it.

### Example

```
$ ./update_dns.sh -4
Updated DOMAIN from 1:2:3:4:5:6:7:8 to 1.2.3.4
HTTP200
Status 0 is acceptable.
```
```
$ ./update_dns.sh -6
Updated DOMAIN from 1.2.3.4 to 1:2:3:4:5:6:7:8
HTTP200
Status 0 is acceptable.
```

## Afraid.org Version 1 Instructions

Add one of these to your crontab. Basically what the script does without fancy
options and checks. Please be concious of how often you knock on the servers,
and preferably add a 30-45 second sleep so that you do not hit near :00 seconds.

```
*/4 * * * * sleep 28; curl http://freedns.afraid.org/dynamic/update.php?YOUR_V1_KEY_GOES_HERE
```
```
*/7 * * * * sleep 42; wget -O http://freedns.afraid.org/dynamic/update.php?YOUR_V1_KEY_GOES_HERE
```

## Other Dynamic DNS Hosts

### No-IP.org Instructions

Please see this guide on installing the Dynamic Update Client (DUC).

https://my.noip.com/dynamic-dns/duc
