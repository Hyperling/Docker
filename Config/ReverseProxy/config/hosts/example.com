# Local servers for everything related to `example.com`.
# If specific ports are needed they will go here instead of the `conf.d` file(s).

# NOTE: 'server hyperling.com;' is used so that the file works in production,
#       it is not part of the example, the commented value is what's important.

upstream example-proxy-site {
    #server 127.0.0.1:8080;
    server hyperling.com;
}

upstream example-git-site {
    #server 127.0.0.1:3000;
    server hyperling.com;
}
