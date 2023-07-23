# Load Balancing Files
Example is TBD, but would looks something like this:

```
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
```

## Official Documentation
http://nginx.org/en/docs/stream/ngx_stream_core_module.html
