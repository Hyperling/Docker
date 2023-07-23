# Example of how to load balance 4 Postgres servers for example.com. Since this
# does not act under a reverse proxy situation, code is commented so that the
# container does not needlessly start listening on the port.

#upstream postgres_servers {
#	server 1.2.3.1:5432;
#	server 1.2.3.2:5432;
#	server 1.2.3.3:5432;
#	server 1.2.3.4:5432;
#}
#
#server {
#	listen 5432;
#	proxy_pass postgres_servers;
#}
