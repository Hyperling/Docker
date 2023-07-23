# Load Balancing Files
Allow requests coming to this server to be spread amongst multiple servers based
on port number. It does not seem possible to spread them based on `server_name`
or other directives like a reverse proxy. The server simply listens on the port
then runs through the upstream list to determine the destination.

## Official Documentation
http://nginx.org/en/docs/stream/ngx_stream_core_module.html
