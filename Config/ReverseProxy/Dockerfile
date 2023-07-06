# 2022-10-05 Hyperling
# Create the nginx environment for a reverse proxy.
# https://docs.docker.com/engine/reference/builder/

FROM nginx

# Add all the configuration files to the environment.
COPY ./config/nginx.conf /etc/nginx/nginx.conf
COPY ./config/conf.d/*.* /etc/nginx/conf.d/

# Create "working" certificates for the example configuration file.
RUN mkdir -p /etc/nginx/certs/example.com
RUN openssl req -new -x509 -days 5000 -nodes \
		-out /etc/nginx/certs/example.com/cert.crt \
		-keyout /etc/nginx/certs/example.com/cert.key \
		-subj '/CN=example.com/O=Example/C=XX'
