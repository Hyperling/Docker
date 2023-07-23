# Example of how to load balance 4 Postgres servers for example.com.

upstream postgres_servers {
	server 1.2.3.1:5432;
	server 1.2.3.2:5432;
	server 1.2.3.3:5432;
	server 1.2.3.4:5432;
}

server {
	listen 5432;
	proxy_pass postgres_servers;
}
