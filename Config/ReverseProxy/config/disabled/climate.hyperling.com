# 20210202 C.Greenwood
# 20230111 - Change to hit WeatherSpark instead of using local grafana server.
# 20230819 - Removes SSL, copied from weather to climate, changed cities to all be in AZ.

server {
  listen 80;
  server_name climate.hyperling.com;
  location / {
    return 301 http://weatherspark.com/compare/y/2636~2628~2874~2477~2857~2840/Comparison-of-the-Average-Weather-in-Flagstaff-Payson-Show-Low-Prescott-Tucson-and-Benson;
  }
}

server {
  listen 443;
  server_name climate.hyperling.com;
  location / {
    return 301 http://$host$request_uri;
  }
}
