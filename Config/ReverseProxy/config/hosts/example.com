# Local servers for everything related to `example.com`.

upstream example-proxy {
    server 127.0.0.1;
}

