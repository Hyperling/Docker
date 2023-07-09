# Local servers for everything related to `example.com`.

upstream example-proxy-site {
    #server 127.0.0.1;
    server hyperling.com;
}

