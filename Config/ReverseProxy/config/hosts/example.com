# Local servers for everything related to `example.com`.
# If specific ports are needed they will go here instead of the `conf.d` file(s).

upstream example-proxy-site {
    #server 127.0.0.1:8080;
    server hyperling.com;
}
